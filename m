Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28EB612D88F
	for <lists+netdev@lfdr.de>; Tue, 31 Dec 2019 13:15:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726677AbfLaMPE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Dec 2019 07:15:04 -0500
Received: from internalmail.cumulusnetworks.com ([45.55.219.144]:47281 "EHLO
        internalmail.cumulusnetworks.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726334AbfLaMPE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Dec 2019 07:15:04 -0500
Received: from localhost (fw.cumulusnetworks.com [216.129.126.126])
        by internalmail.cumulusnetworks.com (Postfix) with ESMTPSA id 37B65C11CA;
        Tue, 31 Dec 2019 04:15:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=cumulusnetworks.com;
        s=mail; t=1577794503;
        bh=VsCncJCn5z/RU8jgpSgndCbcgUiicd8e/CnUzm9LK1w=;
        h=From:To:Cc:Subject:Date;
        b=WDHGIaOC/xyNKYWZAfmVmE+1nqKyhyHuDM8pdZCvRk2MbS/5NUg4RFTYQEe3wQu54
         hHIA28nGxzpJfh0eJPQu11rr0/mRjYDk+wY7UxvKWupqjlaM2asipSkXyDVkseTL4a
         Mp1ccoZs5S+O4fg1t+QpOo30kKD2x36Orut4+iHQ=
From:   Andy Roulin <aroulin@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     dsahern@gmail.com, nikolay@cumulusnetworks.com,
        roopa@cumulusnetworks.com, j.vosburgh@gmail.com, vfalico@gmail.com,
        andy@greyhouse.net, aroulin@cumulusnetworks.com
Subject: [PATCH iproute2-next v3 0/2] pretty-print LACP slave state
Date:   Tue, 31 Dec 2019 04:15:00 -0800
Message-Id: <1577794502-8063-1-git-send-email-aroulin@cumulusnetworks.com>
X-Mailer: git-send-email 1.9.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Print the bond slave 802.3ad/LACP state in a human-readable way.
The LACP bond slave actor/partner state definitions are exported
to userspace in the kernel include/uapi.

rtnetlink sends the bond slave state to userspace, see
 - IFLA_BOND_SLAVE_AD_ACTOR_OPER_PORT_STATE; and
 - IFLA_BOND_SLAVE_AD_PARTNER_OPER_PORT_STATE

and these are only printed as numbers, e.g.,

ad_actor_oper_port_state 15

Add an additional output in ip link show that prints a string describing
the individual 3ad bit meanings.

ad_actor_oper_port_state_str <active,short_timeout,aggregating,in_sync>

JSON output is also supported, the field becomes a json array:

"ad_actor_oper_port_state_str":
	["active","short_timeout","aggregating","in_sync"]

These changes are dependent on a kernel change to uapi/ in net-next;
the following patches are the changes and are already in net-next:
[PATCH net-next v2] bonding: move 802.3ad port state flags to uapi
[PATCH net-next v2] bonding: rename AD_STATE_* to LACP_STATE_*

v2:
 - address patch format and comments

v3:
 - prefix state defines with LACP_*

Andy Roulin (2):
  include/uapi: update bonding kernel header
  iplink: bond: print 3ad actor/partner oper states as strings

 include/uapi/linux/if_bonding.h | 16 +++++++--------
 ip/iplink_bond_slave.c          | 36 +++++++++++++++++++++++++++++----
 2 files changed, 40 insertions(+), 12 deletions(-)

-- 
2.20.1

