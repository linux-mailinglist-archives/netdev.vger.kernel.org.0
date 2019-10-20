Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F88CDDEE6
	for <lists+netdev@lfdr.de>; Sun, 20 Oct 2019 16:37:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726487AbfJTOgb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Oct 2019 10:36:31 -0400
Received: from mx2a.mailbox.org ([80.241.60.219]:32875 "EHLO mx2a.mailbox.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726349AbfJTOgb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 20 Oct 2019 10:36:31 -0400
Received: from smtp1.mailbox.org (smtp1.mailbox.org [80.241.60.240])
        (using TLSv1.2 with cipher ECDHE-RSA-CHACHA20-POLY1305 (256/256 bits))
        (No client certificate requested)
        by mx2a.mailbox.org (Postfix) with ESMTPS id 13E6CA2287;
        Sun, 20 Oct 2019 16:36:28 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mailbox.org; h=
        content-language:content-transfer-encoding:content-type
        :content-type:mime-version:date:date:message-id:subject:subject
        :from:from:received; s=mail20150812; t=1571582179; bh=33RJF3JIig
        tswEg6/AYekjtWM+I3XvRvL0JYt1AAHP8=; b=lKkiohUCCNBpLwaR3lajXY0yZs
        /+Gke5y7X40BHS3P4jQf21fcLfuM05KmgIDYw3kXCm0d6/nOSpEzuby/ggdFDnLH
        N0+hakS4J1NxKygVaGSBdLesd4bCMhX9UCGeOTQyTSoXx6kmRIOjH3KiEMgF1XBd
        vRAQiT3XIjwhX6EcwCpt9CugqYWzCNzr7aipJxilB1OmhCo7ba6RvBZigATLEGJq
        t7pSws2ctFrXt6NGRa9eSzsDf/mUFvzGEbZFaT7R4WNOaYCrdyPoZg7mb5730/hd
        N+GmdWsbg0MCUkKjRCQHFwzEsMbAxt/m7BoHfMY0+dTPREDqLwe1BggYaUuA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
        t=1571582186;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=TTgzGv/nSI9GT8GUwIz6X2yO4G3ZjBstkEl/HIetUvA=;
        b=yoQnFwU8jtb27oAyeiPjaXtHevyGfIclaQz4n0rR3EMEPuI4P4A4SHLVYbMp4dlMscaJJq
        al0Ap5TXtUhxZdBUSXk2vCH4dpmsyajWuAOjtGNYVor2es3qBIw2cD7BoqsJQYaOo8Y1rX
        /fyzY/B9LUWCIm74kvt7eMZVSw8UbyIETr9irVyYN2KaWg5bNCmVSslt1uUYfodg3ALVG3
        rGUvvKTWgoGYhhBQ8LpEHh5Yf2VNMijh3hXWpKHONO4QOBoLRgnUZPEhS2yLaxF6NZb791
        dZ5xXrI4XV3UhHSiyT43kGSa6rsgF02ewSa3PKNBdZqMmtQ5uAjsFZk1w2eVSA==
X-Virus-Scanned: amavisd-new at heinlein-support.de
Received: from smtp1.mailbox.org ([80.241.60.240])
        by spamfilter02.heinlein-hosting.de (spamfilter02.heinlein-hosting.de [80.241.56.116]) (amavisd-new, port 10030)
        with ESMTP id N1Mo07V6SBpc; Sun, 20 Oct 2019 16:36:19 +0200 (CEST)
From:   e-m <e-m@mailbox.org>
Subject: [PATCH] allow ipv6 lladdr for ip6gre
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org
Message-ID: <b8d174d7-b9d5-1387-4875-ca5f702fe842@mailbox.org>
Date:   Sun, 20 Oct 2019 16:36:18 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I recently noticed that its not possible to set ipv6 lladdr for ip6gre 
tunnels using iproute2.

That is because the parser (int ll_addr_a2n()) treats ipv6 addresses as 
mac addresses because of the ":".

I dont know iproute2 good enough to say if the patch below breaks 
anything so please only look at this as a proof of concept.

Thanks for reading.


Best regards,

Etienne Muesse


// Testing:

ip nei add fdaa::6 lladdr fdbb::6 dev ip6gre123

-> "fdbb" is invalid lladdr.

Does not work with current version of iproute2 but with patch below.


---
  lib/ll_addr.c | 60 ++++++++++++++++++++++++---------------------------
  1 file changed, 28 insertions(+), 32 deletions(-)

diff --git a/lib/ll_addr.c b/lib/ll_addr.c
index 00b562ae..996901bf 100644
--- a/lib/ll_addr.c
+++ b/lib/ll_addr.c
@@ -49,41 +49,37 @@ const char *ll_addr_n2a(const unsigned char *addr, 
int alen, int type,
  /*NB: lladdr is char * (rather than u8 *) because sa_data is char * 
(1003.1g) */
  int ll_addr_a2n(char *lladdr, int len, const char *arg)
  {
-    if (strchr(arg, '.')) {
-        inet_prefix pfx;
-        if (get_addr_1(&pfx, arg, AF_INET)) {
-            fprintf(stderr, "\"%s\" is invalid lladdr.\n", arg);
+    inet_prefix pfx;
+    int i;
+
+    if (get_addr_1(&pfx, arg, AF_UNSPEC) == 0) {
+        if (len < pfx.bytelen)
              return -1;
+        memcpy(lladdr, pfx.data, pfx.bytelen);
+        return pfx.bytelen;
+    }
+
+    for (i = 0; i < len; i++) {
+        int temp;
+        char *cp = strchr(arg, ':');
+        if (cp) {
+            *cp = 0;
+            cp++;
          }
-        if (len < 4)
+        if (sscanf(arg, "%x", &temp) != 1) {
+            fprintf(stderr, "\"%s\" is invalid lladdr.\n",
+                arg);
+            return -1;
+        }
+        if (temp < 0 || temp > 255) {
+            fprintf(stderr, "\"%s\" is invalid lladdr.\n",
+                arg);
              return -1;
-        memcpy(lladdr, pfx.data, 4);
-        return 4;
-    } else {
-        int i;
-
-        for (i = 0; i < len; i++) {
-            int temp;
-            char *cp = strchr(arg, ':');
-            if (cp) {
-                *cp = 0;
-                cp++;
-            }
-            if (sscanf(arg, "%x", &temp) != 1) {
-                fprintf(stderr, "\"%s\" is invalid lladdr.\n",
-                    arg);
-                return -1;
-            }
-            if (temp < 0 || temp > 255) {
-                fprintf(stderr, "\"%s\" is invalid lladdr.\n",
-                    arg);
-                return -1;
-            }
-            lladdr[i] = temp;
-            if (!cp)
-                break;
-            arg = cp;
          }
-        return i + 1;
+        lladdr[i] = temp;
+        if (!cp)
+            break;
+        arg = cp;
      }
+    return i + 1;
  }
-- 


