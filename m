Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BEB93E3179
	for <lists+netdev@lfdr.de>; Fri,  6 Aug 2021 23:57:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245427AbhHFV5y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Aug 2021 17:57:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245412AbhHFV5x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Aug 2021 17:57:53 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B605C06179A
        for <netdev@vger.kernel.org>; Fri,  6 Aug 2021 14:57:36 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id ca5so18687118pjb.5
        for <netdev@vger.kernel.org>; Fri, 06 Aug 2021 14:57:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AY970ncUJAZ3XFO8vIsQqriyIPN/r8JHpDac7fWieeM=;
        b=GRldI1oetU6ItCaJ5fQcboBOkS3kNm2NJPpnSaaazigE6TM8n6i0NiIJP8y33/Xxwa
         X1jAnVhjjyuIS90Qp8RPwxHhAgqIXbZqVgNoEV0eule5rbSNSOwhCx8kbtPOAu5r+kt7
         l/iGkMkrDTQIRoGctxtnHVFRWFZ5GSeRqK0SQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AY970ncUJAZ3XFO8vIsQqriyIPN/r8JHpDac7fWieeM=;
        b=UoTAE2UyOK0gnrJMX2VHIp1cM6X4atN4Hru9Isr/ezpb5q4X+iyJQt8T+MBikITgRW
         HOeotA4WA3/Ng20dB4a+TJPDLk4HZDIMBKaDqDt4Xz1SqevP9Aup7az97SkXnxl0hxBq
         m/prHARLSlyk4KwsnIFJ8MMSegX9CEspaqUMqqiZlTBZ6I54LLrjhneBeBm0lTCN/gdz
         L0wtvR0XH3+E9qKurnY/9VaNOeOq0DfsNO6HvOQfr5ZQ8E4MLHR7tdFj49NFqypN02C6
         yNJjPtkDERwYQHT3zQ4Th8JOygKHF4XwqGrIQLN55oKxYXiY5rzaI5DcpfMEFl3tgl7H
         QUCw==
X-Gm-Message-State: AOAM531JDr8cVQqu6aU8zsvH/A6589Xj3Nl3PROMfJ9Za8ohR1dUe8Aq
        +ldVwtl/5s/F0Ynt/Io6nG7Yzw==
X-Google-Smtp-Source: ABdhPJzl6uHhzenJtj16rXyHOXA9lloApy8P+OInYnPj3mA9JONQ+nAAQl57sYQLIY6HcAjxwW1oJg==
X-Received: by 2002:a63:d607:: with SMTP id q7mr347628pgg.268.1628287055799;
        Fri, 06 Aug 2021 14:57:35 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id v7sm9814110pjk.37.2021.08.06.14.57.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Aug 2021 14:57:35 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Kees Cook <keescook@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: [PATCH] pcmcia: ray_cs: Split memcpy() to avoid bounds check warning
Date:   Fri,  6 Aug 2021 14:57:33 -0700
Message-Id: <20210806215733.2875927-1-keescook@chromium.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1806; h=from:subject; bh=MoN9sZmmdDw0lR5vW36Fdr39zzqTtcOilmLJ144gA30=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBhDbBMeJZHHO3+hbAJbiz+YaA05/E7kfaAlhhB+qwX bgM8lUWJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYQ2wTAAKCRCJcvTf3G3AJhexD/ kB913c39c5/NcFF+4Bg7joDZ0bnRbO13Ww9Wcn2hoK3sgl3q35x2wuzAdruejBJR/7gKFmzHIor4am aQJFNLZmnb6GPsvPww07WjJfTTEL2aIlKw6+RWECbMmIYaZ37VzT15AZWr7/vFYGDiK3mdL9xbL/me Cqo5qkyChQRNlo/+/yNVveUiJl+1pMkhAmiBJtqpSbz/wsuhbUHV6CTpAr0QbVgJ016V/YJq7thei/ Cxa0BcbWyYKVWQLlUIX5ZHYSD/jLrNRFd6//Q/VIQDxOYsOmsi+CpByAkVxj+lZSZY6tKX8r3nNlOn 7QP7eGd/6oYfB2vi/QzQi0xblqs/V0+YUydIQl82RZVXNrZ4lt2XuUWH0jDHKJA4FFWzIhxEU2zzqO u6boGH1JLSgNFuIqvxpAz2jC0jdOgJzEv7J1/ixrvO2YX1Qwn7wkEuZF1CPlnqb/kbIwhw9xROvpaJ UbKIBV6X3neOI7A6xFItNCs1/NMdpia3JLKGL1rOlEAa+4LJvYDTOk8P64wH6mXxcNW2BfXIMdCM1K 7uSnblp9J+MeWF5KAkfhocRvIvvSLERrXvxiHUeewIlTIZr4emNWe5kaN3svEFMY98VTx6nZI6VQd9 EEqmYPMVOmWup8WfcCrwxyCI6XU8OI1DxJN9glwcxMBWsW1g9DqqZnU9uh1g==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation for FORTIFY_SOURCE performing compile-time and run-time
field bounds checking for memcpy(), memmove(), and memset(), avoid
intentionally writing across neighboring fields.

Split memcpy() for each address range to help memcpy() correctly reason
about the bounds checking. Avoids the future warning:

In function 'fortify_memcpy_chk',
    inlined from 'memcpy_toio' at ./include/asm-generic/io.h:1204:2,
    inlined from 'ray_build_header.constprop' at drivers/net/wireless/ray_cs.c:984:3:
./include/linux/fortify-string.h:285:4: warning: call to '__write_overflow_field' declared with attribute warning: detected write beyond size of field (1st parameter); maybe use struct_group()? [-Wattribute-warning]
  285 |    __write_overflow_field(p_size_field, size);
      |    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/net/wireless/ray_cs.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ray_cs.c b/drivers/net/wireless/ray_cs.c
index 590bd974d94f..d57bbe551630 100644
--- a/drivers/net/wireless/ray_cs.c
+++ b/drivers/net/wireless/ray_cs.c
@@ -982,7 +982,9 @@ AP to AP	1	1	dest AP		src AP		dest	source
 	if (local->net_type == ADHOC) {
 		writeb(0, &ptx->mac.frame_ctl_2);
 		memcpy_toio(ptx->mac.addr_1, ((struct ethhdr *)data)->h_dest,
-			    2 * ADDRLEN);
+			    ADDRLEN);
+		memcpy_toio(ptx->mac.addr_2, ((struct ethhdr *)data)->h_source,
+			    ADDRLEN);
 		memcpy_toio(ptx->mac.addr_3, local->bss_id, ADDRLEN);
 	} else { /* infrastructure */
 
-- 
2.30.2

