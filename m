Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D3B55897D
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 20:08:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726655AbfF0SII (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 14:08:08 -0400
Received: from namei.org ([65.99.196.166]:49158 "EHLO namei.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726519AbfF0SII (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Jun 2019 14:08:08 -0400
Received: from localhost (localhost [127.0.0.1])
        by namei.org (8.14.4/8.14.4) with ESMTP id x5RI6c5Z018737;
        Thu, 27 Jun 2019 18:06:38 GMT
Date:   Fri, 28 Jun 2019 04:06:38 +1000 (AEST)
From:   James Morris <jmorris@namei.org>
To:     Stephen Smalley <sds@tycho.nsa.gov>
cc:     Andy Lutomirski <luto@amacapital.net>,
        Andy Lutomirski <luto@kernel.org>,
        Matthew Garrett <matthewgarrett@google.com>,
        linux-security@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>,
        David Howells <dhowells@redhat.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Matthew Garrett <mjg59@google.com>,
        Network Development <netdev@vger.kernel.org>,
        Chun-Yi Lee <jlee@suse.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        linux-security-module@vger.kernel.org
Subject: Re: [PATCH V33 24/30] bpf: Restrict bpf when kernel lockdown is in
 confidentiality mode
In-Reply-To: <bce70c8b-9efd-6362-d536-cfbbcf70b0b7@tycho.nsa.gov>
Message-ID: <alpine.LRH.2.21.1906280332500.17363@namei.org>
References: <20190621011941.186255-1-matthewgarrett@google.com> <20190621011941.186255-25-matthewgarrett@google.com> <CALCETrVUwQP7roLnW6kFG80Cc5U6X_T6AW+BTAftLccYGp8+Ow@mail.gmail.com> <alpine.LRH.2.21.1906270621080.28132@namei.org>
 <6E53376F-01BB-4795-BC02-24F9CAE00001@amacapital.net> <bce70c8b-9efd-6362-d536-cfbbcf70b0b7@tycho.nsa.gov>
User-Agent: Alpine 2.21 (LRH 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 27 Jun 2019, Stephen Smalley wrote:

> There are two scenarios where finer-grained distinctions make sense:
> 
> - Users may need to enable specific functionality that falls under the
> umbrella of "confidentiality" or "integrity" lockdown.  Finer-grained lockdown
> reasons free them from having to make an all-or-nothing choice between lost
> functionality or no lockdown at all.

Agreed. This will be used for more than just UEFI secure boot on desktops, 
e.g. embedded systems using verified boot, where finer grained policy will 
be needed for what are sometimes very specific use-cases (which may be 
also covered by other mitigations).

> This can be supported directly by the
> lockdown module without any help from SELinux or other security modules; we
> just need the ability to specify these finer-grained lockdown levels via the
> boot parameters and securityfs nodes.

If the lockdown LSM implements fine grained policy (rather than the simple 
coarse grained policy), I'd suggest adding a new lockdown level of 
'custom' which by default enables all hooks but allows selective 
disablement via params/sysfs.

This would be simpler than telling users to use a different lockdown LSM 
for this.

> - Different processes/programs may need to use different sets of functionality
> restricted via lockdown confidentiality or integrity categories.  If we have
> to allow all-or-none for the set of interfaces/functionality covered by the
> generic confidentiality or integrity categories, then we'll end up having to
> choose between lost functionality or overprivileged processes, neither of
> which is optimal.
> 
> Is it truly the case that everything under the "confidentiality" category
> poses the same level of risk to kernel confidentiality, and similarly for
> everything under the "integrity" category?  If not, then being able to
> distinguish them definitely has benefit.

Good question. We can't know the answer to this unless we know how an 
attacker might leverage access.

The value here IMHO is more in allowing tradeoffs to be made by system 
designers vs. disabling lockdown entirely.

> I'm still not clear though on how/if this will compose with or be overridden
> by other security modules.  We would need some means for another security
> module to take over lockdown decisions once it has initialized (including
> policy load), and to be able to access state that is currently private to the
> lockdown module, like the level.

Why not utilize stacking (restrictively), similarly to capabilities?


-- 
James Morris
<jmorris@namei.org>

