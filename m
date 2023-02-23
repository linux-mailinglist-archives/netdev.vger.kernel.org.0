Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 890D66A084A
	for <lists+netdev@lfdr.de>; Thu, 23 Feb 2023 13:12:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234124AbjBWMM1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Feb 2023 07:12:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233897AbjBWMMX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Feb 2023 07:12:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AE8030B03;
        Thu, 23 Feb 2023 04:12:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BDC5E616C3;
        Thu, 23 Feb 2023 12:11:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79E6AC433D2;
        Thu, 23 Feb 2023 12:11:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677154311;
        bh=tf69zYIBWxJ0Ke0TeASxjm7DirQL5qfZAnwMoKjMDdE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UKwFSpbFN/gJmz8poWh9c+4stsKmoOATtCRgUoSmxt7L+AAKeMFE6PX+J8Mafit/K
         0/4ymIJgyVY+ULwuyCOwjp1OIYXT1tcFVzeACvmqdFUmhQEenyfYDCHNi7+fG7wZ9i
         ycJV8tmQ3CqH+JrTpvPnbGsK0QdRlFhrtEA73vJIr8F6EuonyaQL72kfHnbeKgXy1z
         cPCe8c3tWxCHrzVfc6YHZpLGUMykOeJF0ZMeQjRMYosSUePDMr3ri+F8AjG3k4tplX
         JjWFjayZ74Qpj/tL97c7yZRw8kjXL2HMdfvAb1cwiQTp9oFLBn8RAJG+pt3UCJ27IA
         ENKj8QkvHF47g==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        saeedm@nvidia.com, tariqt@nvidia.com, leon@kernel.org,
        shayagr@amazon.com, akiyano@amazon.com, darinzon@amazon.com,
        sgoutham@marvell.com, lorenzo.bianconi@redhat.com, toke@redhat.com
Subject: [RFC net-next 1/6] tools: ynl: fix render-max for flags definition
Date:   Thu, 23 Feb 2023 13:11:33 +0100
Message-Id: <0252b7d3f7af70ce5d9da688bae4f883b8dfa9c7.1677153730.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <cover.1677153730.git.lorenzo@kernel.org>
References: <cover.1677153730.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Properly manage render-max property for flags definition type
introducing mask value and setting it to (last_element << 1) - 1
instead of adding max value set to last_element + 1

Fixes: be5bea1cc0bf ("net: add basic C code generators for Netlink")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 tools/net/ynl/ynl-gen-c.py | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/tools/net/ynl/ynl-gen-c.py b/tools/net/ynl/ynl-gen-c.py
index 3942f24b9163..161ae02bee54 100755
--- a/tools/net/ynl/ynl-gen-c.py
+++ b/tools/net/ynl/ynl-gen-c.py
@@ -1995,9 +1995,14 @@ def render_uapi(family, cw):
 
             if const.get('render-max', False):
                 cw.nl()
-                max_name = c_upper(name_pfx + 'max')
-                cw.p('__' + max_name + ',')
-                cw.p(max_name + ' = (__' + max_name + ' - 1)')
+                if const['type'] == 'flags':
+                    max_name = c_upper(name_pfx + 'mask')
+                    max_val = f' = {(entry.user_value() << 1) - 1},'
+                    cw.p(max_name + max_val)
+                else:
+                    max_name = c_upper(name_pfx + 'max')
+                    cw.p('__' + max_name + ',')
+                    cw.p(max_name + ' = (__' + max_name + ' - 1)')
             cw.block_end(line=';')
             cw.nl()
         elif const['type'] == 'const':
-- 
2.39.2

