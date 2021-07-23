Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17B4E3D3BFB
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 16:48:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235443AbhGWOH4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 10:07:56 -0400
Received: from serv108.segi.ulg.ac.be ([139.165.32.111]:59443 "EHLO
        serv108.segi.ulg.ac.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235406AbhGWOHz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Jul 2021 10:07:55 -0400
Received: from localhost.localdomain (148.24-240-81.adsl-dyn.isp.belgacom.be [81.240.24.148])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by serv108.segi.ulg.ac.be (Postfix) with ESMTPSA id D03C520AE95F;
        Fri, 23 Jul 2021 16:48:26 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 serv108.segi.ulg.ac.be D03C520AE95F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uliege.be;
        s=ulg20190529; t=1627051706;
        bh=bI5icVtR/jkn6Si+Va3Rg3RCRPbLhKUStEOHzP1FS0g=;
        h=From:To:Cc:Subject:Date:From;
        b=iT2+WCUX1x8s083yNgPocnVjwRBkndrFT2YciLIxQv3b7+FnLesvaqwTGSba6t/ma
         PxEjxp9SPHAAvofdbnwC2GJSBwP0NB5pV++23ltgd29iInrcL1wZIjy5WY+ZDbQ9Ek
         OlXf++20SY/bMHSe+aqtBU6P2QICa3vsr1UGMuC6QgZ+YbvQPtI08I411N996dfVKX
         PCCp2A+FyyW+oPHRSWnYeX6joza0CNxPiTdbmZ7FawTTJnxr+LnvCSRemi7iQ9ayBN
         +XFKGMR6WIzF18JMqwTw0sRDbmuQrIOhcqkRjLGTUGQn+SN/rjDbvitNf8d+lubk2F
         Hm++f5W7HGQJQ==
From:   Justin Iurman <justin.iurman@uliege.be>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, justin.iurman@uliege.be
Subject: [PATCH iproute2-next 0/3] Provide support for IOAM
Date:   Fri, 23 Jul 2021 16:47:59 +0200
Message-Id: <20210723144802.14380-1-justin.iurman@uliege.be>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The IOAM patchset was merged yesterday (see net-next commits [1,2,3,4,5,6]).
Therefore, this patchset provides support for IOAM inside iproute2, as well as
manpage documentation. Here is a summary of added features inside iproute2.

(1) configure IOAM namespaces and schemas:

$ ip ioam
Usage:	ip ioam { COMMAND | help }
	ip ioam namespace show
	ip ioam namespace add ID [ data DATA32 ] [ wide DATA64 ]
	ip ioam namespace del ID
	ip ioam schema show
	ip ioam schema add ID DATA
	ip ioam schema del ID
	ip ioam namespace set ID schema { ID | none }
	
(2) provide a new encap type to insert the IOAM pre-allocated trace:

$ ip -6 ro ad fc00::1/128 encap ioam6 trace type 0x800000 ns 1 size 12 dev eth0

  [1] db67f219fc9365a0c456666ed7c134d43ab0be8a
  [2] 9ee11f0fff205b4b3df9750bff5e94f97c71b6a0
  [3] 8c6f6fa6772696be0c047a711858084b38763728
  [4] 3edede08ff37c6a9370510508d5eeb54890baf47
  [5] de8e80a54c96d2b75377e0e5319a64d32c88c690
  [6] 968691c777af78d2daa2ee87cfaeeae825255a58

Justin Iurman (3):
  Add, show, link, remove IOAM namespaces and schemas
  New IOAM6 encap type for routes
  IOAM man8

 include/uapi/linux/ioam6.h          | 133 +++++++++++
 include/uapi/linux/ioam6_genl.h     |  52 +++++
 include/uapi/linux/ioam6_iptunnel.h |  20 ++
 include/uapi/linux/lwtunnel.h       |   1 +
 ip/Makefile                         |   2 +-
 ip/ip.c                             |   3 +-
 ip/ip_common.h                      |   1 +
 ip/ipioam6.c                        | 351 ++++++++++++++++++++++++++++
 ip/iproute.c                        |   5 +-
 ip/iproute_lwtunnel.c               | 121 ++++++++++
 man/man8/ip-ioam.8                  |  72 ++++++
 man/man8/ip-route.8.in              |  35 ++-
 man/man8/ip.8                       |   7 +-
 13 files changed, 797 insertions(+), 6 deletions(-)
 create mode 100644 include/uapi/linux/ioam6.h
 create mode 100644 include/uapi/linux/ioam6_genl.h
 create mode 100644 include/uapi/linux/ioam6_iptunnel.h
 create mode 100644 ip/ipioam6.c
 create mode 100644 man/man8/ip-ioam.8

-- 
2.25.1

