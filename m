Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C02B629021A
	for <lists+netdev@lfdr.de>; Fri, 16 Oct 2020 11:43:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406098AbgJPJlZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Oct 2020 05:41:25 -0400
Received: from smtp44.i.mail.ru ([94.100.177.104]:46514 "EHLO smtp44.i.mail.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405757AbgJPJlY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Oct 2020 05:41:24 -0400
X-Greylist: delayed 9749 seconds by postgrey-1.27 at vger.kernel.org; Fri, 16 Oct 2020 05:41:23 EDT
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=inbox.ru; s=mail3;
        h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:Cc:To:From:From:Subject:Content-Type:Content-Transfer-Encoding:To:Cc; bh=VxtFqTzKn8D1XEyz/xBV/bsI+NnzNkxZyb+HkVyGK4o=;
        b=iCKbaE7MHLkPhTP8TK9Xz1ih1crZT5Wlr/PuSb7hQZiVUz0FnieQVsDzrVTvkA2+W7eJVK/J4YoP+9qe2VzGFWe30CF5UUan4t6j2+dploZ0LiWQDbpsRre+dxK+LDQMDYHsaaE4QJ1Mk/oBnsIOqPvD303fbzyc5aUidTvQsXU=;
Received: by smtp44.i.mail.ru with esmtpa (envelope-from <fido_max@inbox.ru>)
        id 1kTMEi-0003oD-Gq; Fri, 16 Oct 2020 12:41:20 +0300
From:   Maxim Kochetkov <fido_max@inbox.ru>
To:     netdev@vger.kernel.org
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "David S . Miller" <davem@davemloft.net>,
        Maxim Kochetkov <fido_max@inbox.ru>
Subject: [PATCH v3 1/1] net: dsa: seville: the packet buffer is 2 megabits, not megabytes
Date:   Fri, 16 Oct 2020 12:41:55 +0300
Message-Id: <20201016094155.532088-1-fido_max@inbox.ru>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Authentication-Results: smtp44.i.mail.ru; auth=pass smtp.auth=fido_max@inbox.ru smtp.mailfrom=fido_max@inbox.ru
X-7564579A: B8F34718100C35BD
X-77F55803: 4F1203BC0FB41BD9E98D7292067252302C0E76C52979D672675FED68DAFAF9FC182A05F538085040F0F085F7325A13BE9F0A50A0FFDA5A3FAD68637CE4A81A5F8879B4B06EC84300
X-7FA49CB5: FF5795518A3D127A4AD6D5ED66289B5278DA827A17800CE7DECE8D0A5E25C0FCEA1F7E6F0F101C67BD4B6F7A4D31EC0BCC500DACC3FED6E28638F802B75D45FF8AA50765F79006370D3D68FCEFFDD9EA8638F802B75D45FF5571747095F342E8C7A0BC55FA0FE5FCB9D2E28F37CB8F4A2E6A346629DEDBF9B1FAF873BDB81B56389733CBF5DBD5E913377AFFFEAFD269176DF2183F8FC7C06030C3405640F6718941B15DA834481FCF19DD082D7633A0E7DDDDC251EA7DABA471835C12D1D977725E5C173C3A84C3E478A468B35FE767117882F4460429728AD0CFFFB425014E592AE0A758652A3D76E601842F6C81A19E625A9149C048EE7532CA1512B81981FCB1554B277F7060D8FC6C240DEA76429449624AB7ADAF37B2D370F7B14D4BC40A6AB1C7CE11FEE3540F9B2D9BA47D5603F1AB874ED89028C4224003CC8364767A15B7713DBEF166A7F4EDE966BC389F9E8FC8737B5C224959DF8EA86ED09BA9089D37D7C0E48F6CCF19DD082D7633A0E7DDDDC251EA7DABAAAE862A0553A39223F8577A6DFFEA7C4BBCEF8A9559A4AE43847C11F186F3C5E7DDDDC251EA7DABCC89B49CDF41148FA8EF81845B15A4842623479134186CDE6BA297DBC24807EABDAD6C7F3747799A
X-C8649E89: 0D0D877C87F70461655CE65291C019C320FB086E9003A5B2FD2A454D30892B09E3D94FCD835E4469
X-D57D3AED: 3ZO7eAau8CL7WIMRKs4sN3D3tLDjz0dLbV79QFUyzQ2Ujvy7cMT6pYYqY16iZVKkSc3dCLJ7zSJH7+u4VD18S7Vl4ZUrpaVfd2+vE6kuoey4m4VkSEu530nj6fImhcD4MUrOEAnl0W826KZ9Q+tr5ycPtXkTV4k65bRjmOUUP8cvGozZ33TWg5HZplvhhXbhDGzqmQDTd6OAevLeAnq3Ra9uf7zvY2zzsIhlcp/Y7m53TZgf2aB4JOg4gkr2biojYVZa6UGX9HTn7u1vVV2ahQ==
X-Mailru-Sender: 11C2EC085EDE56FA9C10FA2967F5AB242BE1615B0E2CD00D5493889C515CF79CBBE8FF8006AF1AAFEE9242D420CFEBFD3DDE9B364B0DF2891A624F84B2C74EDA4239CF2AF0A6D4F80DA7A0AF5A3A8387
X-Mras: Ok
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The VSC9953 Seville switch has 2 megabits of buffer split into 4360
words of 60 bytes each. 2048 * 1024 is 2 megabytes instead of 2 megabits.
2 megabits is (2048 / 8) * 1024 = 256 * 1024.

Signed-off-by: Maxim Kochetkov <fido_max@inbox.ru>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Fixes: a63ed92d217f ("net: dsa: seville: fix buffer size of the queue system")
---
 drivers/net/dsa/ocelot/seville_vsc9953.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/ocelot/seville_vsc9953.c b/drivers/net/dsa/ocelot/seville_vsc9953.c
index 9e9fd19e1d00..e2cd49eec037 100644
--- a/drivers/net/dsa/ocelot/seville_vsc9953.c
+++ b/drivers/net/dsa/ocelot/seville_vsc9953.c
@@ -1010,7 +1010,7 @@ static const struct felix_info seville_info_vsc9953 = {
 	.vcap_is2_keys		= vsc9953_vcap_is2_keys,
 	.vcap_is2_actions	= vsc9953_vcap_is2_actions,
 	.vcap			= vsc9953_vcap_props,
-	.shared_queue_sz	= 2048 * 1024,
+	.shared_queue_sz	= 256 * 1024,
 	.num_mact_rows		= 2048,
 	.num_ports		= 10,
 	.mdio_bus_alloc		= vsc9953_mdio_bus_alloc,
-- 
2.27.0

