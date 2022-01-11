Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12B5048B4A4
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 18:54:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344862AbiAKRyq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 12:54:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344769AbiAKRyn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 12:54:43 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 791F8C06173F
        for <netdev@vger.kernel.org>; Tue, 11 Jan 2022 09:54:43 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id i8-20020a17090a138800b001b3936fb375so6727171pja.1
        for <netdev@vger.kernel.org>; Tue, 11 Jan 2022 09:54:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Dcd0/g4UbnpmQf2lYWpQMozVkbYSJ8CoZkn58HCH4Ik=;
        b=PVptpwA9gU9pbg9aVcASMDv94FS06VmUj1TGnyqdV+Doc286rQSIHqhQzDEvCcuedS
         aBExTLUhh9wPKfyLpCGZbQayGW2yFlWcv3/FtCzCTk03+JUDjsKoBM/YJBS7rIg8RXgd
         mLImNKYTQd31Fln3xuQK9xHzO30pwtjTh+NAe5NvaeJ/zZauYlv/WhuwVdhlGlB6w2ZQ
         BPvDzRgUfCWsv3KW/0a+1QLL605rPCg/XIRNUmtwJQJLJTXg2B4n6ncy3K9DoyB620oM
         jLxtCzyYag+4nPt6Xuap6jOrJ9KJ4IJeCJJqEXgNUOXrQJ/JQlpK/laWX6dc27znemVj
         oxOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Dcd0/g4UbnpmQf2lYWpQMozVkbYSJ8CoZkn58HCH4Ik=;
        b=uA6MG1ABZpPbk1MdBjvUqob+yDRKBjguqQvtg2+XAtYcd+6IYn91ZZCmoSmAjMCmz+
         7WRc2gE5rmBFIZHb4F8Hldc+qvZSNn2JS8SZZI0uHrVfcKeMPLOp315U+ydt37VxD52R
         oNn1g8OxTj5YuwPjA+j0hkTconfEFb/e9iKYLuiYFmeWIoqL0dMWpLeQixQeJ/ZB8K5P
         NntzzShlUm9eYToDhj8rshrDvwsBnd8yoBYn86w5NJJTEgEAX4H75csy3RwTNUVwyMTA
         prJITTe4bRbbx8lhoHqaet03PzLL3GgKn1zbS6n0u4jWyQVbL6ifik0wLpgWU9aIKLMl
         7Qsw==
X-Gm-Message-State: AOAM531YEFayJWHju4xLl9b02aahbXHx34tbS4VgKeGskYnkjQHjjCwa
        FzaWlFjJ4qgw4ZPuYhFKeM3j6bfKDYyEVg==
X-Google-Smtp-Source: ABdhPJxEJDBgo6Of5z8gJaW2wzVz4qhsGKDnEKtBU1ReH27Q2Utct3R99AOJoDmjQG3bmoM9tfeFFg==
X-Received: by 2002:a17:90b:1d8c:: with SMTP id pf12mr4505311pjb.42.1641923682698;
        Tue, 11 Jan 2022 09:54:42 -0800 (PST)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id f8sm23925pga.69.2022.01.11.09.54.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Jan 2022 09:54:42 -0800 (PST)
From:   Stephen Hemminger <stephen@networkplumber.org>
X-Google-Original-From: Stephen Hemminger <sthemmin@microsoft.com>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH v2 iproute2-next 01/11] tc: add format attribute to tc_print_rate
Date:   Tue, 11 Jan 2022 09:54:28 -0800
Message-Id: <20220111175438.21901-2-sthemmin@microsoft.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220111175438.21901-1-sthemmin@microsoft.com>
References: <20220111175438.21901-1-sthemmin@microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stephen Hemminger <stephen@networkplumber.org>

This catches future errors and silences warning from Clang.

Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
---
 tc/tc_util.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tc/tc_util.c b/tc/tc_util.c
index 48065897cee7..6d5eb754831a 100644
--- a/tc/tc_util.c
+++ b/tc/tc_util.c
@@ -247,7 +247,8 @@ int get_percent_rate64(__u64 *rate, const char *str, const char *dev)
 	return get_rate64(rate, r_str);
 }
 
-void tc_print_rate(enum output_type t, const char *key, const char *fmt,
+void __attribute__((format(printf, 3, 0)))
+tc_print_rate(enum output_type t, const char *key, const char *fmt,
 		   unsigned long long rate)
 {
 	print_rate(use_iec, t, key, fmt, rate);
-- 
2.30.2

