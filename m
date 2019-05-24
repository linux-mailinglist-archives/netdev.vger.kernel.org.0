Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE6C029D09
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 19:34:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390483AbfEXReo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 13:34:44 -0400
Received: from mail-vs1-f65.google.com ([209.85.217.65]:35602 "EHLO
        mail-vs1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725923AbfEXReo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 13:34:44 -0400
Received: by mail-vs1-f65.google.com with SMTP id q13so6366246vso.2
        for <netdev@vger.kernel.org>; Fri, 24 May 2019 10:34:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GQaSpiIxbKy5UlGRdPSgaQ4pt4Z1le4Cnao3BsjrRIY=;
        b=nHHl9Z6e5RN/hFk8JcC+SPVhR2GdtS6ZPJDSbKHn54wng8ZDQA8rhqVg0uQFFfQBhq
         4rlooWtpcvrxoClWSvP77VCdwxzhvKveoztAM7YLPZnYmoJFFFgAiZ0TwjF1PFlBMzP4
         NmcnxQTZVaGIjR8s3qEUNT0ZhSLnGkY0ZHDtgSUPl9KpheuiBHO452eGDoqvabcTgCUS
         e38ggdmcWmbuyAYlwoRO+PgVI2fJKNze18YI84MsxqrQ92Ebdk3/6sjIxgkJz63tCyPD
         hZzw+ZlF35jWi67ZIFDWljieixj8Ax9oi+xSbwDBV/1lej7yui70tjEYYvGSt+cOhSg1
         W8kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GQaSpiIxbKy5UlGRdPSgaQ4pt4Z1le4Cnao3BsjrRIY=;
        b=TsKH5YR11dD5epw+OgmspqT/SMOPXTj8fRdXUTMwUHEBOHbi5A3c4nT8hTLl/RaVcm
         JUtREztpvPDjaVmd3MmahZYe3LIrYI2qtT0M22VNL04j1OoOMtXzO4sZQ1NG8WgaUSKK
         Q7Wg2GQJloPJyaZJQaOreWgE5dkck7qelRLrLRYXA/xEsJrgL91i4P1PQGWQWdjkgjh1
         /on9rn3pnqwFz1XtadHi2njlyzf/fu7RXeqAxJrPWIb8VT495Xb8Ph9BdWlhYvtg1olJ
         kBTRNtJDglo5HOz8rIPFiIBpHdJhHBBRNpS4u3tKRJYB8KTJj859yMJciY9R3xB2X+m/
         omjw==
X-Gm-Message-State: APjAAAXF7seV2ijaQu8eNuLTR3mvG4rjYFBZTKoDa+8ZnZjOKj2CbDtt
        NGs+U2FLf+7vgJTk+lcJTF28pw==
X-Google-Smtp-Source: APXvYqxkbhb0e5y9vBFJOIG5N9dcL0uvfy3ayd4UfE7CeIwIDh4W8P7ZfqChYwXvAVfvrg84lQ5++Q==
X-Received: by 2002:a67:f59a:: with SMTP id i26mr42183011vso.168.1558719282961;
        Fri, 24 May 2019 10:34:42 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id n23sm2025647vsj.27.2019.05.24.10.34.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 24 May 2019 10:34:42 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        davejwatson@fb.com, john.fastabend@gmail.com, vakul.garg@nxp.com,
        alexei.starovoitov@gmail.com,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH net 0/4] net/tls: two fixes for rx_list pre-handling
Date:   Fri, 24 May 2019 10:34:29 -0700
Message-Id: <20190524173433.9196-1-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi!

tls_sw_recvmsg() had been modified to cater better to async decrypt.
Partially read records now live on the rx_list. Data is copied from
this list before the old do {} while loop, and the not included
correctly in deciding whether to sleep or not and lowat threshold
handling. These modifications, unfortunately, added some bugs.

First patch fixes lowat - we need to calculate the threshold early
and make sure all copied data is compared to the threshold, not just
the freshly decrypted data.

Third patch fixes sleep - if data is picked up from rx_list and
no flags are set, we should not put the process to sleep, but
rather return the partial read.

Patches 2 and 4 add test cases for these bugs, both will cause
a sleep and test timeout before the fix.

Jakub Kicinski (4):
  net/tls: fix lowat calculation if some data came from previous record
  selftests/tls: test for lowat overshoot with multiple records
  net/tls: fix no wakeup on partial reads
  selftests/tls: add test for sleeping even though there is data

 net/tls/tls_sw.c                  | 19 +++++++-----------
 tools/testing/selftests/net/tls.c | 33 +++++++++++++++++++++++++++++++
 2 files changed, 40 insertions(+), 12 deletions(-)

-- 
2.21.0

