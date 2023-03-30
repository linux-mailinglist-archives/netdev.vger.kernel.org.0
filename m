Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0E866D0A4D
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 17:47:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233321AbjC3Pri (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 11:47:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233227AbjC3Prh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 11:47:37 -0400
Received: from forwardcorp1b.mail.yandex.net (forwardcorp1b.mail.yandex.net [IPv6:2a02:6b8:c02:900:1:45:d181:df01])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC02D9777;
        Thu, 30 Mar 2023 08:47:14 -0700 (PDT)
Received: from mail-nwsmtp-smtp-corp-main-44.iva.yp-c.yandex.net (mail-nwsmtp-smtp-corp-main-44.iva.yp-c.yandex.net [IPv6:2a02:6b8:c0c:7f29:0:640:9a2b:0])
        by forwardcorp1b.mail.yandex.net (Yandex) with ESMTP id B932D5FC8F;
        Thu, 30 Mar 2023 18:47:11 +0300 (MSK)
Received: from den-plotnikov-w.yandex-team.ru (unknown [2a02:6b8:b081:8002::1:4])
        by mail-nwsmtp-smtp-corp-main-44.iva.yp-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id 3lLKP30OeqM0-eth6G5p0;
        Thu, 30 Mar 2023 18:47:11 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1680191231; bh=tC5GEPVXxrpQQqeYqSc0uqWbQAmF/7QDNrrnUxUxgl4=;
        h=Message-Id:Date:Cc:Subject:To:From;
        b=Fq9FSOTMLPVX2DdZQ13SB7rSBFbGiAEZOzc/0GEkIdH/mzF5jD4tRtUvZDsIv1jah
         wEBQPynQx2oi/c4YpOGzzWs/f5w5pJp5RJiuR1KEaJ/c/C54erUg/fj6bjSUN7+NOj
         DGRsE7zOcczXMlxMXorqxI+YkEm2SSd0JGiDC9hM=
Authentication-Results: mail-nwsmtp-smtp-corp-main-44.iva.yp-c.yandex.net; dkim=pass header.i=@yandex-team.ru
From:   Denis Plotnikov <den-plotnikov@yandex-team.ru>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, rajur@chelsio.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, den-plotnikov@yandex-team.ru
Subject: [PATCH] cxgb4: do conversion after string check
Date:   Thu, 30 Mar 2023 18:47:03 +0300
Message-Id: <20230330154703.36958-1-den-plotnikov@yandex-team.ru>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Static code analyzer complains to uncheck return value.
Indeed, the return value of kstrtouint "must be checked"
as the comment says.
Moreover, it looks like the string conversion  should be
after "end of string" or "new line" check.
This patch fixes these issues.

Signed-off-by: Denis Plotnikov <den-plotnikov@yandex-team.ru>
---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c
index 14e0d989c3ba5..a8d3616630cc6 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c
@@ -1576,9 +1576,11 @@ inval:				count = -EINVAL;
 		}
 		if (*word == '@') {
 			end = (char *)word + 1;
-			ret = kstrtouint(end, 10, &j);
 			if (*end && *end != '\n')
 				goto inval;
+			ret = kstrtouint(end, 10, &j);
+			if (ret)
+				goto inval;
 			if (j & 7)          /* doesn't start at multiple of 8 */
 				goto inval;
 			j /= 8;
-- 
2.25.1

