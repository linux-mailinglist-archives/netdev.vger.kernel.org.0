Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42BF25E6CF9
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 22:23:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229728AbiIVUXo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 16:23:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229688AbiIVUXn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 16:23:43 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0592E110ED7
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 13:23:42 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id v186so2477422pfv.11
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 13:23:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=rnAvdVu9FLu4hHv77Hq5ubLTsOszBSQGiSlWfmI2aZ4=;
        b=kE6za50xvtoastKvMIJRTIGHsR3JNvDBA8AnSVVBZ7+qfsQ0N6KrP1ml7dZm4lvZOD
         UgCW/Y++wX+aihZOGtVFMzSzjba/Ejn0LYEmszKLAsGUfEhqQgfAFh3s22u3LkeTHsSb
         c2yZ2tKofdsPKgUMtyz+t4gPaBWTNJ5GzfkiHwNUYusCetiZHM4nKjWKdAO+PLYey9ls
         1DEyrFIdt8DMkhmz9inif/4VZpby02U+7IbUtKWyjgz7erfuyZEubS3WtmKQGUjcGELe
         pPs4Gc3FeGcoeIcwzZ296e5CZJmPiWjOiWdDVP/QnevGY5xpWMIpbPAQDp5IOoOBQa8g
         0Gqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=rnAvdVu9FLu4hHv77Hq5ubLTsOszBSQGiSlWfmI2aZ4=;
        b=QiOkW5VmXquj07KyAoZoMsQ8l5u93WI+yk2c33dCpbsEWGGGEwbzXN3r8IgFJUsc4V
         5QLSP9fkddiToafllPcmzxbE55fH41Na17X2tjJRMbYCFIlp8iWQ6hdrPTNh7W0hMs1f
         ZUeNdJ/HYYX+VhKZqP5a2H6YN78IvSezRa5//R7h3TomiivTX8sTVCNHWya5h0SM4S/9
         BRBg6orXr6J2fT2yTU1zWRWVvtIG7NApb49LBBL0rZf0AzEB2j8on6evQawag+Wqr1G+
         g+bsY31PETO/YyS9UrGsO5KsUqlEwafiDJwve4YTETjSAW9qJBCyYkHeSirySL5NGvcG
         xs2A==
X-Gm-Message-State: ACrzQf0n63h0asX1Jz3ErTLqpsGCcrqxah8+fHbzSgJvg0FudSQ37ysv
        wipzTeXzVyqHX/fxymZxEt9Q+S8/wItYyA==
X-Google-Smtp-Source: AMsMyM4qvEC/Guf3tdC1kRI3dUlyCSiXHylfJP+UC90zfvcOP5hZd/Euh9mdrPmZNB7sPBXE6zDLUw==
X-Received: by 2002:a63:1554:0:b0:43b:f03d:8651 with SMTP id 20-20020a631554000000b0043bf03d8651mr4411783pgv.422.1663878221879;
        Thu, 22 Sep 2022 13:23:41 -0700 (PDT)
Received: from localhost.localdomain (lily-optiplex-3070.dynamic.ucsd.edu. [2607:f720:1300:3033::1:4dd])
        by smtp.googlemail.com with ESMTPSA id k18-20020aa79732000000b00545832dd969sm4934312pfg.145.2022.09.22.13.23.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Sep 2022 13:23:41 -0700 (PDT)
From:   Li Zhong <floridsleeves@gmail.com>
To:     netdev@vger.kernel.org, v9fs-developer@lists.sourceforge.net
Cc:     pabeni@redhat.com, kuba@kernel.org, edumazet@google.com,
        davem@davemloft.net, linux_oss@crudebyte.com,
        asmadeus@codewreck.org, lucho@ionkov.net, ericvh@gmail.com,
        Li Zhong <floridsleeves@gmail.com>
Subject: [PATCH net-next v2] net/9p/trans_fd: check the return value of parse_opts
Date:   Thu, 22 Sep 2022 13:23:21 -0700
Message-Id: <20220922202321.1705245-1-floridsleeves@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

parse_opts() could fail when there is error parsing mount options into
p9_fd_opts structure due to allocation failure. In that case opts will
contain invalid data. Though the value check on opts will prevent
invalid data from being used, we still add the check and return the
error code to avoid confusions for developers.

Signed-off-by: Li Zhong <floridsleeves@gmail.com>
---
 net/9p/trans_fd.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/9p/trans_fd.c b/net/9p/trans_fd.c
index e758978b44be..11ae64c1a24b 100644
--- a/net/9p/trans_fd.c
+++ b/net/9p/trans_fd.c
@@ -1061,7 +1061,9 @@ p9_fd_create(struct p9_client *client, const char *addr, char *args)
 	int err;
 	struct p9_fd_opts opts;
 
-	parse_opts(args, &opts);
+	err = parse_opts(args, &opts);
+	if (err < 0)
+		return err;
 	client->trans_opts.fd.rfd = opts.rfd;
 	client->trans_opts.fd.wfd = opts.wfd;
 
-- 
2.25.1

