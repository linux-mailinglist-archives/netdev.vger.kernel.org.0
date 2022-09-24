Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B15755E8828
	for <lists+netdev@lfdr.de>; Sat, 24 Sep 2022 06:08:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233212AbiIXEIm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Sep 2022 00:08:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233084AbiIXEIj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Sep 2022 00:08:39 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F26C13EADF
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 21:08:39 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id fv3so1757707pjb.0
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 21:08:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=KTpXWyUfll++z7HAP03By+eA9GIaY84D+3kNuRJY2h8=;
        b=EKUUevtGtyBMzrNFQzypBqYj20XXKLIIjEykNJuC6WbBX77P4whhxWmu/HidER0vfh
         hY47+ITassozPqvsIj5G6eOmByCur8iVlGihQ4EscY8gDO9VX8tiSb/aDKgWOwCIt9Ab
         JO8de+j0fVZPNG+xGUc1ofG17CXcmR2YFe364=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=KTpXWyUfll++z7HAP03By+eA9GIaY84D+3kNuRJY2h8=;
        b=rfjQjCsw+AtvSqsIroYQmteIshlZjAkSjImkpPJ2TDDByYaBbe5vY6TS+GOgu2heEb
         MBPTRr2FmLCvQ/WMJFH98ziFJJdxUcXHl5uKv4cU1Q9bbxYFpvGthaNw07VrNus1g6Co
         ltghpIE5hZtUPzx9+rrdcYZpxOsgeEZmS86DjSUDU3xAraW181aWWaE77YVCSOSJaTYi
         TAU1AwLbovaFlLgeB2kZZ2ll4Rh3Mcj8dLZFP6mz0heGaKP+4Zu7e4s/y8ikQi/terZf
         8CQSYsa4UKTpMwbCFNTKufvE+9s8N5DdxnKI22qoG/GT7XaZUg4eZ470MkxShQytod7v
         8B2A==
X-Gm-Message-State: ACrzQf1eqj1usX8sBFKiPa/hQCNef/uExpPv9ynDnst+nzZShWF2kY2n
        7zVTOMzgPVsV4vAPiISTqktyRXjnD6/gEA==
X-Google-Smtp-Source: AMsMyM71MzhI6cppP1wRrRHYJPrClOj8l4ZKb0OLA8RhQdAePaq9ZRI4HNFyzeBwHwsstrixVbdU2A==
X-Received: by 2002:a17:902:e494:b0:178:5b6d:636 with SMTP id i20-20020a170902e49400b001785b6d0636mr11292050ple.64.1663992518563;
        Fri, 23 Sep 2022 21:08:38 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id z12-20020a6553cc000000b0041d6d37deb5sm6413190pgr.81.2022.09.23.21.08.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Sep 2022 21:08:37 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     Kees Cook <keescook@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: [PATCH] NFC: hci: Split memcpy() of struct hcp_message flexible array
Date:   Fri, 23 Sep 2022 21:08:35 -0700
Message-Id: <20220924040835.3364912-1-keescook@chromium.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1692; h=from:subject; bh=L3jycFmba5E2CH09pA5cygiCtitH/bmlm+CqI6heXOk=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBjLoLD0YsYw2J2xQ0tZE9KGrEoJ8NYLRlKPkcvzZqz yQEQEbyJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYy6CwwAKCRCJcvTf3G3AJk4LEA ClWkoy6IOy1qfx50hwizKTjj+BKE2WJ46hPcko+MF5I0MZ6Q4ZATjEiGbraCyQGgtwYzk8cLV9p8gQ 8GKPpSW0UJojL6M7Hc3ucQo7yVKecKiBbJnVHX41ZLSARp5binAPgqa5RbCttvbBwbznrihcKb7DTs w/5Wkc0UBwh+yUMHTpvzMGwtamUHlQXDKNIoS26Osa4pBT5M3AD3rsJWcuDEVTSrQOMxBvcJwHkaIY xvXsS00hHt1OK/JRz290YhG0SN/sORY5owHBJAUGwoRo7lwoqcJPWyG/ejOCJLk1wOxXFdAUE2sUMY mTt3ewUROH/wBSuhk3tjZbEVGrzokGmfhiLLoMRZyBvc96zzi34I3JuEU1rOWaC05ufU2FLv7yIwur UrwkV3GHMIxXi0+Yx37Ty5KhZaQydPHbZwLfaJnpaIq3FU0ay2BGVnI1eaPQzewRe/Z6XixsBh5tBs d5Qx3+G46QMvlLNIPsRYn+tuH+6tUuCKPPA6ySkZaSfp3a69YISMghumcZLBFMTh9TPejpmy8/ECWq IgqQ6y0Jq4xC1WE06cgdkiHTJNpAC85uTT8hj+wCOSqtbkjpoSPyUAbHn/DtjyEhXoWsf0QsRdC+t2 rIQSEM25WqhwuUwEipx/MEvW3e8Jhwd/X8f4lmiT5SfwTV4GuVeqO820uA5g==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To work around a misbehavior of the compiler's ability to see into
composite flexible array structs (as detailed in the coming memcpy()
hardening series[1]), split the memcpy() of the header and the payload
so no false positive run-time overflow warning will be generated. This
split already existed for the "firstfrag" case, so just generalize the
logic further.

[1] https://lore.kernel.org/linux-hardening/20220901065914.1417829-2-keescook@chromium.org/

Cc: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: netdev@vger.kernel.org
Reported-by: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 net/nfc/hci/hcp.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/net/nfc/hci/hcp.c b/net/nfc/hci/hcp.c
index 05c60988f59a..4902f5064098 100644
--- a/net/nfc/hci/hcp.c
+++ b/net/nfc/hci/hcp.c
@@ -73,14 +73,12 @@ int nfc_hci_hcp_message_tx(struct nfc_hci_dev *hdev, u8 pipe,
 		if (firstfrag) {
 			firstfrag = false;
 			packet->message.header = HCP_HEADER(type, instruction);
-			if (ptr) {
-				memcpy(packet->message.data, ptr,
-				       data_link_len - 1);
-				ptr += data_link_len - 1;
-			}
 		} else {
-			memcpy(&packet->message, ptr, data_link_len);
-			ptr += data_link_len;
+			packet->message.header = *ptr++;
+		}
+		if (ptr) {
+			memcpy(packet->message.data, ptr, data_link_len - 1);
+			ptr += data_link_len - 1;
 		}
 
 		/* This is the last fragment, set the cb bit */
-- 
2.34.1

