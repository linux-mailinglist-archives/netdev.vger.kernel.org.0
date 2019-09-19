Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55ABDB7062
	for <lists+netdev@lfdr.de>; Thu, 19 Sep 2019 03:20:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731509AbfISBTs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Sep 2019 21:19:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48704 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727114AbfISBTs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Sep 2019 21:19:48 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E6F8D308FC4A;
        Thu, 19 Sep 2019 01:19:46 +0000 (UTC)
Received: from madcap2.tricolour.ca (ovpn-112-19.phx2.redhat.com [10.3.112.19])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9723A60C18;
        Thu, 19 Sep 2019 01:19:31 +0000 (UTC)
Date:   Wed, 18 Sep 2019 21:19:28 -0400
From:   Richard Guy Briggs <rgb@redhat.com>
To:     cgroups@vger.kernel.org,
        Linux Containers <containers@lists.linux-foundation.org>,
        Linux API <linux-api@vger.kernel.org>,
        Linux Audit <linux-audit@redhat.com>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Network Development <netdev@vger.kernel.org>
Cc:     mszeredi@redhat.com, Andy Lutomirski <luto@kernel.org>,
        jlayton@redhat.com, Carlos O'Donell <carlos@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        David Howells <dhowells@redhat.com>,
        Simo Sorce <simo@redhat.com>, trondmy@primarydata.com,
        Eric Paris <eparis@parisplace.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>, dwalsh@redhat.com,
        mpatel@redhat.com
Subject: RFC(V4): Audit Kernel Container IDs
Message-ID: <20190919011928.nsr4leqnomgumaac@madcap2.tricolour.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.43]); Thu, 19 Sep 2019 01:19:47 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Containers are a userspace concept.  The kernel knows nothing of them.

The Linux audit system needs a way to be able to track the container
provenance of events and actions.  Audit needs the kernel's help to do
this.

The motivations are:

- A sysadmin needs to be able to filter unwanted, irrelevant or
  unimportant messages before they fill the queue so that important
  messages don't get lost.  This is a certification requirement.

- Security claims need to be made about containers, requiring tracking
  of actions within those containers to ensure compliance with
  established security policies.

- It will be required to route messages from events local to an audit
  daemon instance or host audit daemon instance.

- nsIDs were considered seriously, but turns out to be insufficient for
  efficient filtering, routing, and tracking.

Since the concept of a container is entirely a userspace concept, a
registration from the userspace container orchestration system initiates
this.  This will define a point in time and a set of resources
associated with a particular container with an audit container
identifier.

The registration is a u64 representing the audit container identifier.

This is written to a special file in a pseudo filesystem (proc, since
PID tree already exists) representing a process that will become a
parent process in that container.  This write might place restrictions
on mount namespaces required to define a container, or at least careful
checking of namespaces in the kernel to verify permissions of the
orchestrator so it can't change its own container ID.  A bind mount of
nsfs may be necessary in the container orchestrator's mount namespace.
This write can only happen once per process.

Note: The justification for using a u64 is that it minimizes the
information printed in every audit record, reducing bandwidth and limits
comparisons to a single u64 which will be faster and less error-prone.

[ALT:
The registration is a
netlink message to the audit subsystem of type AUDIT_SET_CONTID with a
data structure including a u32 representing the PID of the target
process to become the parent process in that container and a
u64 representing the audit container identifier.
:ALT]

Require CAP_AUDIT_CONTROL to be able to carry out the registration.  At
that time, record the target container's user-supplied audit container
identifier along with a target container's parent process (which may
become the target container's "init" process) process ID (referenced
from the initial PID namespace) in a new record AUDIT_CONTAINER_OP with
a qualifying op=$action field.

Issue a new auxilliary record AUDIT_CONTAINER_ID for each valid
audit container identifier present on an auditable action or event.

Forked and cloned processes inherit their parent's audit container
identifier, referenced from the process' task_struct indirectly in the
audit pointer to a struct audit_task_info.  Since the audit
container identifier is inherited rather than written, it can still be
written once.  This will prevent tampering while allowing nesting.

Mimic setns(2) and return an error if the process has already initiated
threading or forked since this registration should happen before the
process execution is started by the orchestrator and hence should not
yet have any threads or children.  If this is deemed overly restrictive,
switch all of the target's threads and children to the new containerID.

Trust the orchestrator to judiciously use and restrict CAP_AUDIT_CONTROL.

The audit container identifier will be stored in a refcounted kernel
object that is searchable in a hashtabled list for efficient access.
This is so that multiple container orchestrators/engines can operate on
one machine without danger of them trampling each other's audit
container identifiers.  The owner of each container will also be stored
to be able to permit tasks to be injected into an existing container
only by its owner.

The total number of containers can be restricted by a total count.

To permit nesting containers, the target container must be a descendant
process of the container orchestrator and the container's parent
container (if set) will be stored in the audit container identifier
kernel object.  Report the chain of contids back to the top level
container of a process.  Filters will check the chain of contids back to
the top container.

The total depth of container nesting can be restricted.

When a container ceases to exist because the last process in that
container has exited log the fact to balance the registration action.  
(This is likely needed for certification accountability.)

At this point it appears unnecessary to add a container session
identifier since this is all tracked from loginuid and sessionid to
communicate with the container orchestrator to spawn an additional
session into an existing container which would be logged.  It can be
added at a later date without breaking API should it be deemed
necessary.

To permit container nesting beyond the initial user namespace, add a
capcontid flag per process in its audit audit_task_info struct to store
this ability communicated either via /proc/PID/capcontid or an audit
netlink message type AUDIT_SET_CAPCONTID.

The following namespace logging actions are not needed for certification
purposes at this point, but are helpful for tracking namespace activity.
These are auxilliary records that are associated with namespace
manipulation syscalls unshare(2), clone(2) and setns(2), so the records
will only show up if explicit syscall rules have been added to document
this activity.

Log the creation of every namespace, inheriting/adding its spawning
process' audit container identifier(s), if applicable.  Include the
spawning and spawned namespace IDs (device and inode number tuples).
[AUDIT_NS_CREATE, AUDIT_NS_DESTROY] [clone(2), unshare(2), setns(2)]
Note: At this point it appears only network namespaces may need to track
container IDs apart from processes since incoming packets may cause an
auditable event before being associated with a process.  Since a
namespace can be shared by processes in different containers, the
namespace will need to track all containers to which it has been
assigned.

Upon registration, the target process' namespace IDs (in the form of a
nsfs device number and inode number tuple) will be recorded in an
AUDIT_NS_INFO auxilliary record.

Log the destruction of every namespace that is no longer used by any
process, including the namespace IDs (device and inode number tuples).
[AUDIT_NS_DESTROY] [process exit, unshare(2), setns(2)]

Issue a new auxilliary record AUDIT_NS_CHANGE listing (opt: op=$action)
the parent and child namespace IDs for any changes to a process'
namespaces. [setns(2)]
Note: It may be possible to combine AUDIT_NS_* record formats and
distinguish them with an op=$action field depending on the fields
required for each message type.

The audit container identifier will need to be reaped from all
implicated namespaces upon the destruction of a container.

This namespace information adds supporting information for tracking
events not attributable to specific processes.

Changelog:

(Upstream V4)
- Add elaborated motivations.
- Switch AUDIT_CONTAINER to AUDIT_CONTAINER_OP
- Switch AUDIT_CONTAINER_INFO to AUDIT_CONTAINER_ID
- Add capcontid to mimic CAP_AUDIT_CONTROL in non-init user namespaces
- Check for max contid depth
- Check for max contid quantity
- Store the contid in a refcounted kernel object filed by hashtable
  lists
- Mediate contid registration between peer orchestrators
- Allow injection of processes into an existing container by container
  owner

(Upstream V3)
- switch back to u64 (from pmoore, can be expanded to u128 in future if
  need arises without breaking API.  u32 was originally proposed, up to
  c36 discussed)
- write-once, but children inherit audit container identifier and can
  then still be written once
- switch to CAP_AUDIT_CONTROL
- group namespace actions together, auxilliary records to namespace
  operations.

(Upstream V2)
- switch from u64 to u128 UUID
- switch from "signal" and "trigger" to "register"
- restrict registration to single process or force all threads and
  children into same container

- RGB

--
Richard Guy Briggs <rgb@redhat.com>
Sr. S/W Engineer, Kernel Security, Base Operating Systems
Remote, Ottawa, Red Hat Canada
IRC: rgb, SunRaycer
Voice: +1.647.777.2635, Internal: (81) 32635
