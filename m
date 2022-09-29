Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F62C5EF128
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 11:02:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235039AbiI2JCH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 05:02:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235655AbiI2JCD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 05:02:03 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4949313A95C;
        Thu, 29 Sep 2022 02:01:59 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id l8so496137wmi.2;
        Thu, 29 Sep 2022 02:01:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=BbbyRqTZb58MZyknIV18c+dkMwpbAIaYbZKhhMdqf6A=;
        b=End0u7rPhEoJ1n00iYcAkQL65pJHfxorC5uDkAMnUvayY6+uhkamQjgJ0WAWJdjpf9
         iNErOSYucEDOB4oZ3RxsTNn6vJGKeV53+9yHETPb+tNN+TPhcSrx6CQDxTBPo8RmihzH
         CB9P6q/RyvdJ/pZlwfxjDv067056BQcyPpzCQ1N4sSXIYcYgcnOQZ4S6SCKp9NIFE/lW
         v1zZvMLBDAcNl7tzSYXNEG55xOUEM7tvXQIWdU5g2K1bZH3kv9j+WvEvajUbLw2JQVaP
         ZjDhr0bfC66HH8K985nIPX8wce+kZQ9Bti1lspTU31v1m6bHIur8vR+qL+Hcs55Q8qvY
         hDSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=BbbyRqTZb58MZyknIV18c+dkMwpbAIaYbZKhhMdqf6A=;
        b=7F+GAucpug4bz/d63i3GjSoUodUo6wEmWlg1I80scEnAnrgl/ZkjXBj2r7ZFOa9aoW
         O737ltxfT/tHhlwvNLoy1wgCLvF20akaeHmqGn+UNRdyK5GAkELVxszwZmEOh+oZ5uYK
         pU6n2ayEWj9xgAvCWykbAQYPq/03zNJrvqspj6LWOUI0GW5GlmWm8UNemG4dBvlCMSEE
         7XbnH8vjESiMVDbG4ocXHAccLrw1sgKIomkjCzb1cUoRqeMmeCMd83M/blEd2BIu+RHT
         5dIf149b65hZZBQhHfD80Ptv1DJU1nPfYuFEUnaTShC3po3YhV3b/wtQObfMypkIp8pe
         w8Lg==
X-Gm-Message-State: ACrzQf2PYFk0ZJKZWHHInJyXVaaZKzZeoJwe4KgKxr2oo/nfnGkh4w3G
        jSn5gYazIKER5qUx5nCh7nE=
X-Google-Smtp-Source: AMsMyM5v4ACY3+42OnBQwHiIQO/hoaUCaRWKCu116YhNJE55vp9DxPA055iRWoSLnAr62hz6dDJjJQ==
X-Received: by 2002:a05:600c:524a:b0:3b5:290:1a7c with SMTP id fc10-20020a05600c524a00b003b502901a7cmr10009010wmb.75.1664442117513;
        Thu, 29 Sep 2022 02:01:57 -0700 (PDT)
Received: from localhost.localdomain (90-231-185-32-no122.tbcn.telia.com. [90.231.185.32])
        by smtp.gmail.com with ESMTPSA id v4-20020a5d4b04000000b0022c96d3b6f2sm7951062wrq.54.2022.09.29.02.01.56
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 29 Sep 2022 02:01:56 -0700 (PDT)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com
Cc:     jonathan.lemon@gmail.com, bpf@vger.kernel.org
Subject: [PATCH bpf-next] selftests/xsk: fix double free
Date:   Thu, 29 Sep 2022 11:01:33 +0200
Message-Id: <20220929090133.7869-1-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.34.1
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

From: Magnus Karlsson <magnus.karlsson@intel.com>

Fix a double free at exit of the test suite.

Fixes: a693ff3ed561 ("selftests/xsk: Add support for executing tests on physical device")
Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 tools/testing/selftests/bpf/xskxceiver.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/tools/testing/selftests/bpf/xskxceiver.c b/tools/testing/selftests/bpf/xskxceiver.c
index ef33309bbe49..d1a5f3218c34 100644
--- a/tools/testing/selftests/bpf/xskxceiver.c
+++ b/tools/testing/selftests/bpf/xskxceiver.c
@@ -1953,9 +1953,6 @@ int main(int argc, char **argv)
 
 	pkt_stream_delete(tx_pkt_stream_default);
 	pkt_stream_delete(rx_pkt_stream_default);
-	free(ifobj_rx->umem);
-	if (!ifobj_tx->shared_umem)
-		free(ifobj_tx->umem);
 	ifobject_delete(ifobj_tx);
 	ifobject_delete(ifobj_rx);
 

base-commit: 8526f0d6135f77451566463ace6f0fb8b72cedaa
-- 
2.34.1

