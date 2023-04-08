Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D2F96DBC6D
	for <lists+netdev@lfdr.de>; Sat,  8 Apr 2023 20:19:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229786AbjDHSS0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Apr 2023 14:18:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbjDHSS0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Apr 2023 14:18:26 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CEE783C13;
        Sat,  8 Apr 2023 11:18:24 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH nft] main: Error out when combining -i/--interactive and -f/--file
Date:   Sat,  8 Apr 2023 20:18:18 +0200
Message-Id: <20230408181818.72264-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.0 required=5.0 tests=SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These two options are mutually exclusive, display error in that case:

 # nft -i -f test.nft
 Error: -i/--interactive and -f/--file options cannot be combined

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/main.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/src/main.c b/src/main.c
index 9bd25db82343..cb20850b71c5 100644
--- a/src/main.c
+++ b/src/main.c
@@ -405,9 +405,19 @@ int main(int argc, char * const *argv)
 			nft_ctx_set_dry_run(nft, true);
 			break;
 		case OPT_FILE:
+			if (interactive) {
+				fprintf(stderr,
+					"Error: -i/--interactive and -f/--file options cannot be combined\n");
+				exit(EXIT_FAILURE);
+			}
 			filename = optarg;
 			break;
 		case OPT_INTERACTIVE:
+			if (filename) {
+				fprintf(stderr,
+					"Error: -i/--interactive and -f/--file options cannot be combined\n");
+				exit(EXIT_FAILURE);
+			}
 			interactive = true;
 			break;
 		case OPT_INCLUDEPATH:
-- 
2.30.2

