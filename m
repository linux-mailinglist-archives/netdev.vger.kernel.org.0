Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D17239902
	for <lists+netdev@lfdr.de>; Sat,  8 Jun 2019 00:38:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731827AbfFGWig (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 18:38:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:48660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731766AbfFGWiV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 Jun 2019 18:38:21 -0400
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 58B4D20840;
        Fri,  7 Jun 2019 22:38:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559947100;
        bh=ceg+F7iwecba3xHBHBDynWI22NEJtvb64T5IIcZmzCg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Gjqzy877gpnmxb3uxxVwDxchOIqFvLz29Z8Fy5f0jP6ROAPQo5wDZMqEI/bMv0vz5
         IxE23KwmENsP0IbWoUG4CbbySbmFvJ5vkfob+FEXNSB+9tifZ2UAjhyfAN9D2mK92i
         LBBK+zAplIru9Cl3cl2mS5pO5S5gKEIbOitAtL8g=
From:   David Ahern <dsahern@kernel.org>
To:     stephen@networkplumber.org
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@gmail.com>
Subject: [PATCH v2 iproute-next 08/10] ip: Add man page for nexthop command
Date:   Fri,  7 Jun 2019 15:38:14 -0700
Message-Id: <20190607223816.27512-9-dsahern@kernel.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190607223816.27512-1-dsahern@kernel.org>
References: <20190607223816.27512-1-dsahern@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Document 'ip nexthop' options in a man page with a few examples.

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 man/man8/ip-nexthop.8 | 196 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 196 insertions(+)
 create mode 100644 man/man8/ip-nexthop.8

diff --git a/man/man8/ip-nexthop.8 b/man/man8/ip-nexthop.8
new file mode 100644
index 000000000000..da87ca3b58b7
--- /dev/null
+++ b/man/man8/ip-nexthop.8
@@ -0,0 +1,196 @@
+.TH IP\-NEXTHOP 8 "30 May 2019" "iproute2" "Linux"
+.SH "NAME"
+ip-nexthop \- nexthop object management
+.SH "SYNOPSIS"
+.sp
+.ad l
+.in +8
+.ti -8
+.B ip
+.RI "[ " ip-OPTIONS " ]"
+.B nexthop
+.RI " { " COMMAND " | "
+.BR help " }"
+.sp
+.ti -8
+
+.ti -8
+.BR "ip nexthop" " { "
+.BR show " | " flush " } "
+.I  SELECTOR
+
+.ti -8
+.BR "ip nexthop" " { " add " | " replace " } id "
+.I ID
+.IR  NH
+
+.ti -8
+.BR "ip nexthop" " { " get " | " del " } id "
+.I  ID
+
+.ti -8
+.IR SELECTOR " := "
+.RB "[ " id
+.IR ID " ] [ "
+.B  dev
+.IR DEV " ] [ "
+.B  vrf
+.IR NAME " ] [ "
+.B  master
+.IR DEV " ] [ "
+.BR  groups " ] "
+
+.ti -8
+.IR NH " := { "
+.BR blackhole " | [ "
+.B  via
+.IR ADDRESS " ] [ "
+.B  dev
+.IR DEV " ] [ "
+.BR onlink " ] [ "
+.B encap
+.IR ENCAP " ] | "
+.B  group
+.IR GROUP " } "
+
+.ti -8
+.IR ENCAP " := [ "
+.IR ENCAP_MPLS " ] "
+
+.ti -8
+.IR ENCAP_MPLS " := "
+.BR mpls " [ "
+.IR LABEL " ] ["
+.B  ttl
+.IR TTL " ]"
+
+.ti -8
+.IR GROUP " := "
+.BR id "[," weight "[/...]"
+
+.SH DESCRIPTION
+.B ip nexthop
+is used to manipulate entries in the kernel's nexthop tables.
+.TP
+ip nexthop add id ID
+add new nexthop entry
+.TP
+ip nexthop replace id ID
+change the configuration of a nexthop or add new one
+.RS
+.TP
+.BI via " [ FAMILY ] ADDRESS"
+the address of the nexthop router, in the address family FAMILY.
+Address family must match address family of nexthop instance.
+.TP
+.BI dev " NAME"
+is the output device.
+.TP
+.B onlink
+pretend that the nexthop is directly attached to this link,
+even if it does not match any interface prefix.
+.TP
+.BI encap " ENCAPTYPE ENCAPHDR"
+attach tunnel encapsulation attributes to this route.
+.sp
+.I ENCAPTYPE
+is a string specifying the supported encapsulation type. Namely:
+
+.in +8
+.BI mpls
+- encapsulation type MPLS
+.sp
+.in -8
+.I ENCAPHDR
+is a set of encapsulation attributes specific to the
+.I ENCAPTYPE.
+
+.in +8
+.B mpls
+.in +2
+.I MPLSLABEL
+- mpls label stack with labels separated by
+.I "/"
+.sp
+
+.B ttl
+.I TTL
+- TTL to use for MPLS header or 0 to inherit from IP header
+.in -2
+
+.TP
+.BI group " GROUP"
+create a nexthop group. Group specification is id with an optional
+weight (id,weight) and a '/' as a separator between entries.
+.TP
+.B blackhole
+create a blackhole nexthop
+.RE
+
+.TP
+ip nexthop delete id ID
+delete nexthop with given id.
+.RE
+
+.TP
+ip nexthop show
+show the contents of the nexthop table or the nexthops
+selected by some criteria.
+.RS
+.TP
+.BI dev " DEV "
+show the nexthops using the given device.
+.TP
+.BI vrf " NAME "
+show the nexthops using devices associated with the vrf name
+.TP
+.BI master " DEV "
+show the nexthops using devices enslaved to given master device
+.TP
+.BI groups
+show only nexthop groups
+.RE
+.TP
+ip nexthop flush
+flushes nexthops selected by some criteria. Criteria options are the same
+as show.
+.RE
+
+.TP
+ip nexthop get id ID
+get a single nexthop by id
+
+.SH EXAMPLES
+.PP
+ip nexthop ls
+.RS 4
+Show all nexthop entries in the kernel.
+.RE
+.PP
+ip nexthop add id 1 via 192.168.1.1 dev eth0
+.RS 4
+Adds an IPv4 nexthop with id 1 using the gateway 192.168.1.1 out device eth0.
+.RE
+.PP
+ip nexthop add id 2 encap mpls 200/300 via 10.1.1.1 dev eth0
+.RS 4
+Adds an IPv4 nexthop with mpls encapsulation attributes attached to it.
+.RE
+.PP
+ip nexthop add id 3 group 1/2
+.RS 4
+Adds a nexthop with id 3. The nexthop is a group using nexthops with ids
+1 and 2 at equal weight.
+.RE
+.PP
+ip nexthop add id 4 group 1,5/2,11
+.RS 4
+Adds a nexthop with id 4. The nexthop is a group using nexthops with ids
+1 and 2 with nexthop 1 at weight 5 and nexthop 2 at weight 11.
+.RE
+.SH SEE ALSO
+.br
+.BR ip (8)
+
+.SH AUTHOR
+Original Manpage by David Ahern <dsahern@kernel.org>
-- 
2.11.0

