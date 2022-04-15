Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A887502861
	for <lists+netdev@lfdr.de>; Fri, 15 Apr 2022 12:34:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348310AbiDOKgl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 06:36:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234985AbiDOKgi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 06:36:38 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA2C9BC87B
        for <netdev@vger.kernel.org>; Fri, 15 Apr 2022 03:34:09 -0700 (PDT)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1650018847;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=arOPMY06Oyz+KbFhqEPI3HuLGZi4z83bPyx4C6Mdh/8=;
        b=zeoAch4mQy8o6f8qjZBjVNQppTu4BUiBZ0Tz26NgIW0+eEFUMhWYM3tN1joZQTWKFIA6bn
        yjWm1urFyfJ0FQpv8yN88Nfw6XmvINB41PyxMxGZ10UXDjPr4vYJ4YeUK3fOdY7Pof/4uS
        /RT4Q6uq7k9hMjLvcrLohIYpU/nLp16piUMtjDWBRWCxStnA7Sq18k6eonoY3EyPKvO54X
        EhRVZeChjbZUZUUI4OT8hAacCXsRm4RdDnD6u8kKCOR96r9lv3m27+8fOkDL0UVqclakZg
        XEnaFHdr2ArcdPtq/7aNMygOfkPpcOzQmsNvSz7HReMItDOON8iaCCQsjwK8yg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1650018847;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=arOPMY06Oyz+KbFhqEPI3HuLGZi4z83bPyx4C6Mdh/8=;
        b=PGmgVOrZrweH8rLkUk7RNEJEaNigmUj69lXyLSbk7s1FsaSF9kE1CxIygqKtks7yvGFOh6
        fVR0QLBHp8VyBjAw==
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>, netdev@vger.kernel.org,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: [PATCH net] net: dsa: hellcreek: Calculate checksums in tagger
Date:   Fri, 15 Apr 2022 12:33:20 +0200
Message-Id: <20220415103320.90657-1-kurt@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In case the checksum calculation is offloaded to the DSA master network
interface, it will include the switch trailing tag. As soon as the switch strips
that tag on egress, the calculated checksum is wrong.

Therefore, add the checksum calculation to the tagger (if required) before
adding the switch tag. This way, the hellcreek code works with all DSA master
interfaces regardless of their declared feature set.

Fixes: 01ef09caad66 ("net: dsa: Add tag handling for Hirschmann Hellcreek switches")
Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
---
 net/dsa/tag_hellcreek.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/net/dsa/tag_hellcreek.c b/net/dsa/tag_hellcreek.c
index f64b805303cd..eb204ad36eee 100644
--- a/net/dsa/tag_hellcreek.c
+++ b/net/dsa/tag_hellcreek.c
@@ -21,6 +21,14 @@ static struct sk_buff *hellcreek_xmit(struct sk_buff *skb,
 	struct dsa_port *dp = dsa_slave_to_port(dev);
 	u8 *tag;
 
+	/* Calculate checksums (if required) before adding the trailer tag to
+	 * avoid including it in calculations. That would lead to wrong
+	 * checksums after the switch strips the tag.
+	 */
+	if (skb->ip_summed == CHECKSUM_PARTIAL &&
+	    skb_checksum_help(skb))
+		return NULL;
+
 	/* Tag encoding */
 	tag  = skb_put(skb, HELLCREEK_TAG_LEN);
 	*tag = BIT(dp->index);
-- 
2.30.2

