Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA7646B67D2
	for <lists+netdev@lfdr.de>; Sun, 12 Mar 2023 17:07:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229710AbjCLQHj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Mar 2023 12:07:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbjCLQHi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Mar 2023 12:07:38 -0400
X-Greylist: delayed 971 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 12 Mar 2023 09:07:36 PDT
Received: from fallback25.i.mail.ru (fallback25.i.mail.ru [79.137.243.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DC8230284
        for <netdev@vger.kernel.org>; Sun, 12 Mar 2023 09:07:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mail.ru; s=mail4;
        h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:Cc:To:From:From:Subject:Content-Type:Content-Transfer-Encoding:To:Cc; bh=UdqRoZ8rmjxnZ17LE+zHB0x/1aCpMhfftcPoVHT7pgM=;
        t=1678637256;x=1678727256; 
        b=X2QUuj03dUB+UNckOrAClcwoO+2KTj+nmOpAF2MiWlIxcb7/GT2tPwN0RFNeQ1mU1Ca/09K/Vx5lufOfP1Pwns4o1VNhotroTXiS/AGkKVhOQgJUn5Xwkt5DoZgWp39kEDGmgx0Y+TaphihQh/8cruvZa2ihKDD5C8mi19kbxtvSm/WJnPTGE2sBMibkYCw8TzYxuHm+yS/eoD/nWbeUJXgystU5AWjmQQVw015NApqNQxkqdIqMPTnKdTBUcpTWN6CMwCKlzvsWNLRd+CGf9IX39SUX0anxmVBAhFhHwVb0nc0spHovpiFUf1uonsWcZiunTPLFeTGAzVicHOVm3w==;
Received: from [10.12.4.14] (port=44684 helo=smtp39.i.mail.ru)
        by fallback25.i.mail.ru with esmtp (envelope-from <listdansp@mail.ru>)
        id 1pbNyl-00AsTS-Ru; Sun, 12 Mar 2023 18:51:23 +0300
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mail.ru; s=mail4;
        h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:Cc:To:From:From:Subject:Content-Type:Content-Transfer-Encoding:To:Cc; bh=UdqRoZ8rmjxnZ17LE+zHB0x/1aCpMhfftcPoVHT7pgM=;
        t=1678636283;x=1678726283; 
        b=qaYZyO09aCdgsNmkno4rc7kj989cOkUm9LE+ZHcCQUHE8nV4RR6lAuW8e7x2ZJv9bW/tp/rXeidCD3VxJspNyB+kcvm+qQvNZAYGC3Aiynyind9SZrQrM4AARqSS0ODodjz1ZrIcIW5iOvA6HUjb58dLFm73TDpySuj6lu6SZMjXD7fSAHiOcx212Mh4DU17noBto1cFdgchlHKX/IBKBFhJnfoXDun40O/mN93bleuWkp112Kdybeedq6W3Xx799ibVl4NFj59m0nVbMHithiNtDvTByc+lPJKbGkuKFcdwf82ijuBTrlUM4MDcxLIy/elkJnr5fnBxDoWxTgaeiw==;
Received: by smtp39.i.mail.ru with esmtpa (envelope-from <listdansp@mail.ru>)
        id 1pbNyW-00FuqP-IJ; Sun, 12 Mar 2023 18:51:09 +0300
From:   Danila Chernetsov <listdansp@mail.ru>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Danila Chernetsov <listdansp@mail.ru>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lvc-project@linuxtesting.org
Subject: [PATCH] net: dsa: vsc73xxx: Fix uninitalized 'val' in vsc73xx_adjust_link
Date:   Sun, 12 Mar 2023 15:50:08 +0000
Message-Id: <20230312155008.7830-1-listdansp@mail.ru>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Mailru-Src: smtp
X-7564579A: B8F34718100C35BD
X-77F55803: 4F1203BC0FB41BD9BCEC41593EBD83573328AE13154FE908333A02E638E8A8D8182A05F538085040BA131452E98B02D3A2D43525F027362765A87E3F7053FFD739B9C8F1741A93F3
X-7FA49CB5: FF5795518A3D127A4AD6D5ED66289B5278DA827A17800CE72F22E6DC541F75D9EA1F7E6F0F101C67BD4B6F7A4D31EC0BCC500DACC3FED6E28638F802B75D45FF8AA50765F79006374D0D183F14C070BA8638F802B75D45FF36EB9D2243A4F8B5A6FCA7DBDB1FC311F39EFFDF887939037866D6147AF826D8D22814C81919C2625231FA6CA7EE31796F9789CCF6C18C3F8528715B7D10C86878DA827A17800CE78A80DFD3A0D2C7BC9FA2833FD35BB23D9E625A9149C048EE0AC5B80A05675ACDF04B652EEC242312D2E47CDBA5A96583BD4B6F7A4D31EC0BC014FD901B82EE079FA2833FD35BB23D27C277FBC8AE2E8BF80095D1ED7F4578A471835C12D1D977C4224003CC836476EB9C4185024447017B076A6E789B0E975F5C1EE8F4F765FC5BFAD0E70065EE5E3AA81AA40904B5D9CF19DD082D7633A078D18283394535A93AA81AA40904B5D98AA50765F790063741BC3E871AF2F68EEC76A7562686271ED91E3A1F190DE8FD2E808ACE2090B5E14AD6D5ED66289B5278DA827A17800CE76631511D42670FFE2EB15956EA79C166A417C69337E82CC275ECD9A6C639B01B78DA827A17800CE7CEB265472FA452CE731C566533BA786AA5CC5B56E945C8DA
X-C1DE0DAB: 0D63561A33F958A575C40842A8D7597B3C13B7181B787DE4B4445C2A65D9C08F4EAF44D9B582CE87C8A4C02DF684249C2E763F503762DF508DC63EAE0DBA7CFC
X-C8649E89: 4E36BF7865823D7055A7F0CF078B5EC49A30900B95165D3475FE4AA98865E235E0F17735419505755771C14B7AF3001C2E5A6D7E85000C7E9C8413E86C1BEE231D7E09C32AA3244C2471231B541CB5E68D9BF48984D7CF61B4DF56057A86259FC2E5D8217768D59A
X-D57D3AED: 3ZO7eAau8CL7WIMRKs4sN3D3tLDjz0dLbV79QFUyzQ2Ujvy7cMT6pYYqY16iZVKkSc3dCLJ7zSJH7+u4VD18S7Vl4ZUrpaVfd2+vE6kuoey4m4VkSEu530nj6fImhcD4MUrOEAnl0W826KZ9Q+tr5ycPtXkTV4k65bRjmOUUP8cvGozZ33TWg5HZplvhhXbhDGzqmQDTd6OAevLeAnq3Ra9uf7zvY2zzsIhlcp/Y7m53TZgf2aB4JOg4gkr2biojN3wBDQf4j7NXr72x5a6kPw==
X-Mailru-Sender: 4CE1109FD677D2770147F6A9E21DCA7B96B4B291D31EA920205419AD0297E0A905EDA15CF47320D67E3C9C7AF06D9E7B78274A4A9E9E44FD3C3897ABF9FF211DE8284E426C7B2D9A5FEEDEB644C299C0ED14614B50AE0675
X-Mras: Ok
X-7564579A: 646B95376F6C166E
X-77F55803: 6242723A09DB00B4BD2EB812D5A6E5F7D3C1BE093F4DBF3EC2B00D8115A09827049FFFDB7839CE9E5B90EA4D390E2144A341A6CB07C3DF6277A1F7C30340ED51D36070016356BAA6
X-7FA49CB5: 0D63561A33F958A5149DD3D5B7CC6ADC5C748E40DA3F7D2B9561E4E87F31C16ECACD7DF95DA8FC8BD5E8D9A59859A8B6A096F61ED9298604
X-D57D3AED: 3ZO7eAau8CL7WIMRKs4sN3D3tLDjz0dLbV79QFUyzQ2Ujvy7cMT6pYYqY16iZVKkSc3dCLJ7zSJH7+u4VD18S7Vl4ZUrpaVfd2+vE6kuoey4m4VkSEu530nj6fImhcD4MUrOEAnl0W826KZ9Q+tr5xhPKz0ZEsZ5k6NOOPWz5QAiZSCXKGQRq3/7KxbCLSB2ESzQkaOXqCBFZPLWFrEGlV1shfWe2EVcxl5toh0c/aCGOghz/frdRhzMe95NxDFdAc2jUOxWGfx/CzOtXP2wag==
X-Mailru-MI: 800
X-Mras: Ok
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Using uninitialized variable after calls vsc73xx_read 
without error checking may cause incorrect driver behavior.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 95711cd5f0b4 ("net: dsa: vsc73xx: Split vsc73xx driver")
Signed-off-by: Danila Chernetsov <listdansp@mail.ru>
---
 drivers/net/dsa/vitesse-vsc73xx-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/vitesse-vsc73xx-core.c b/drivers/net/dsa/vitesse-vsc73xx-core.c
index ae55167ce0a6..729005d6cb7e 100644
--- a/drivers/net/dsa/vitesse-vsc73xx-core.c
+++ b/drivers/net/dsa/vitesse-vsc73xx-core.c
@@ -758,7 +758,7 @@ static void vsc73xx_adjust_link(struct dsa_switch *ds, int port,
 				struct phy_device *phydev)
 {
 	struct vsc73xx *vsc = ds->priv;
-	u32 val;
+	u32 val = 0;
 
 	/* Special handling of the CPU-facing port */
 	if (port == CPU_PORT) {
-- 
2.25.1

