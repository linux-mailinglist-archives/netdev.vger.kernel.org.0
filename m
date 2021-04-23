Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66400368BEB
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 06:18:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236425AbhDWESs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 00:18:48 -0400
Received: from sender4-op-o14.zoho.com ([136.143.188.14]:17474 "EHLO
        sender4-op-o14.zoho.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235302AbhDWESs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Apr 2021 00:18:48 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1619150552; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=cyF6ZYzcO7ENFwPNPgc0RT2cwJzMpr6UUfx8varHiC20ido87HoEqfWP8nF0zmmzrpW2fVdUpuJG/AUpb7HCmLYiG+QEg/ieDL0/AgRH5yA+A+CwaChAHCyGT+SE8iE10z1OX3uTEQtDV6mcmdawS0gGndv3ZrRYqgPLyuIRbZA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1619150552; h=Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=3f/MHuAv6lLyy57kXDD21smInIUne4Nyu2IOKNLZhX8=; 
        b=BW4I80+xefnJkNjTIIrWQT3SaczUXJfhZWYivqP5I+pFtJMli//dVf/Nh8Ilj3YtVY4g/c922TOqNcoRRiQRNKTbXJUjXjsHMWY6sVoW+AajqWwF32Pq36w2WmYhpp2zBUe3A4u5R7ZSNGxJ5qpiB4lNSsY0LxlS1074NCpyzT4=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        spf=pass  smtp.mailfrom=dan@dlrobertson.com;
        dmarc=pass header.from=<dan@dlrobertson.com> header.from=<dan@dlrobertson.com>
Received: from gothmog.test (pool-173-66-46-118.washdc.fios.verizon.net [173.66.46.118]) by mx.zohomail.com
        with SMTPS id 161915054973553.194049103966336; Thu, 22 Apr 2021 21:02:29 -0700 (PDT)
From:   Dan Robertson <dan@dlrobertson.com>
To:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        "David S . Miller" <davem@davemloft.net>,
        linux-wpan@vger.kernel.org, netdev@vger.kernel.org
Cc:     Dan Robertson <dan@dlrobertson.com>
Subject: [PATCH 2/2] net: ieee802154: fix null deref in parse key id
Date:   Fri, 23 Apr 2021 00:02:14 -0400
Message-Id: <20210423040214.15438-3-dan@dlrobertson.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210423040214.15438-1-dan@dlrobertson.com>
References: <20210423040214.15438-1-dan@dlrobertson.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix a logic error that could result in a null deref if the user does not
set the PAN ID but does set the address.

Signed-off-by: Dan Robertson <dan@dlrobertson.com>
---
 net/ieee802154/nl-mac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ieee802154/nl-mac.c b/net/ieee802154/nl-mac.c
index 9c640d670ffe..66983c5d4d85 100644
--- a/net/ieee802154/nl-mac.c
+++ b/net/ieee802154/nl-mac.c
@@ -551,7 +551,7 @@ ieee802154_llsec_parse_key_id(struct genl_info *info,
 	desc->mode = nla_get_u8(info->attrs[IEEE802154_ATTR_LLSEC_KEY_MODE]);
 
 	if (desc->mode == IEEE802154_SCF_KEY_IMPLICIT) {
-		if (!info->attrs[IEEE802154_ATTR_PAN_ID] &&
+		if (!info->attrs[IEEE802154_ATTR_PAN_ID] ||
 		    !(info->attrs[IEEE802154_ATTR_SHORT_ADDR] ||
 		      info->attrs[IEEE802154_ATTR_HW_ADDR]))
 			return -EINVAL;
-- 
2.31.1

