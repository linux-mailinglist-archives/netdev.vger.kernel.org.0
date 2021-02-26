Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E279732699E
	for <lists+netdev@lfdr.de>; Fri, 26 Feb 2021 22:36:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229912AbhBZVgJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Feb 2021 16:36:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229769AbhBZVgI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Feb 2021 16:36:08 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54DC4C061574
        for <netdev@vger.kernel.org>; Fri, 26 Feb 2021 13:35:28 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id h98so9906222wrh.11
        for <netdev@vger.kernel.org>; Fri, 26 Feb 2021 13:35:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=73k62AIoA8b9v2Mg4BxS00yOjJw+j0lbzS4+SWLUw0g=;
        b=ZpkXd7Dp9vjYc/2BW45sLKkp/EZE8lGIK+6hG/fsBS9XSFQHZzD+R57YUeY8Z12FPI
         idB4Yr9AFgP5KCrOEhTpC3xMhaxIjH91bGiz0L3uifmDEssoEmX/MPFLy6vvuoho/tPS
         e8sUPU+pqUZn4rzDl323weFgkZNH5q2nKSrRmZVgOCcKUQcwBeKfXf0k/KtLLo6K8juy
         uFD5c7Ra374F5S0w/ddrc8dhrNkX8BDI8fitIYBQDvfevPy3GZnJB85ZVCkjoU+5Xnem
         UlF/Snj6TwRq+nkn1GTr0m170x3wpNDCwqZA9LlUSurgEQfFsEfjUNW6nPALmqBVCBjV
         TX9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=73k62AIoA8b9v2Mg4BxS00yOjJw+j0lbzS4+SWLUw0g=;
        b=fa5VQt2HRqHJSY62pgOM66tDS3I7Nq/rs2hUDd1dWYoqbqBxoWkV6ifScP+uiLghaa
         6NR0SjLJAZuq5pWvprK66qUTaTeLtrjTkDvgKUO12H75V9RzJNm0bNR+2FancaQkgFCD
         Zsu0Br2tTeXATjf1+zMFIjM36RNZuR5O2hkcu4ot9taNoiS/1//7rHMXVXAcRgQU+dWt
         aBMe8bYs/OPEmPCxzMWTPxfJ/YX8WrOWaq+i+G9HPWlc+5N/FOlrOwhcmFRY5bpDCd46
         gmRO31a/cWfmC0EdYCYwf0OSwnyowOEwq+ZjGl/HrFkXwPV8M9wEnm6Ywgz3rzIEzg3U
         5kdA==
X-Gm-Message-State: AOAM5302rADZSsVtviJR6B1eGga7dw8bjkjdZPaOtWxpM9+l0KPDAKRE
        0ucYDAvoz8eSkaOnMRf3jOU=
X-Google-Smtp-Source: ABdhPJyz8BXaTie9qjhQjxnCPHk81r7bGRMR8sE3CfAtOEmWdhMl0PusPLiZ6cUN5fzGoAJCmqrIxg==
X-Received: by 2002:a5d:68cd:: with SMTP id p13mr5368413wrw.247.1614375326986;
        Fri, 26 Feb 2021 13:35:26 -0800 (PST)
Received: from localhost.localdomain ([213.57.166.51])
        by smtp.gmail.com with ESMTPSA id z11sm17587241wrm.72.2021.02.26.13.35.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Feb 2021 13:35:26 -0800 (PST)
From:   Eyal Birger <eyal.birger@gmail.com>
To:     steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, bram-yvahk@mail.wizbit.be,
        sd@queasysnail.net, Eyal Birger <eyal.birger@gmail.com>
Subject: [PATCH ipsec 0/2] vti(6): fix ipv4 pmtu check to honor ip header df
Date:   Fri, 26 Feb 2021 23:35:04 +0200
Message-Id: <20210226213506.506799-1-eyal.birger@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series aligns vti(6) handling of non-df IPv4 packets exceeding
the size of the tunnel MTU to avoid sending "Frag needed" and instead
fragment the packets after encapsulation.

Eyal Birger (2):
  vti: fix ipv4 pmtu check to honor ip header df
  vti6: fix ipv4 pmtu check to honor ip header df

 net/ipv4/ip_vti.c  | 6 ++++--
 net/ipv6/ip6_vti.c | 6 ++++--
 2 files changed, 8 insertions(+), 4 deletions(-)

-- 
2.25.1

