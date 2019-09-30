Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA119C242B
	for <lists+netdev@lfdr.de>; Mon, 30 Sep 2019 17:22:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731954AbfI3PWq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 11:22:46 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:34373 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731127AbfI3PWq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Sep 2019 11:22:46 -0400
Received: by mail-pf1-f195.google.com with SMTP id b128so5823322pfa.1;
        Mon, 30 Sep 2019 08:22:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=noGn5Fh/vP763HppCbzo5uA2l/ciEILfvzg2KSvFK+k=;
        b=cAtYD8E/qKFCcqdc3ztG6Ggy2HVIuyau9i28VHYQmmwDycAQ+RnFIZP5Cdvogc5FKB
         19ASqk6/KWAiFoKwdBoc0DVlSzRRuFOA0VOEF4CQrEnfYRjr42hv6x6Wot+CgLjFjYvC
         oxih32yZQVkg6qKhYEKWyFzbOh4TrYXdiPt5Ia2PNrHzD1thdECJBpaievj+zpFTf+gP
         FTvESTxIV/txHVaCfvEglzuQdpEPL2ZN6gVfOYxBty4BXyXJ5Rjdh9mylMWjbvxJWetT
         BGJ2/m81vvB4PKIAp507lwsbniZ3rCx10KonVBClDCRUN6rsut1lkGXRrLVgwC+gP6ps
         +gkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=noGn5Fh/vP763HppCbzo5uA2l/ciEILfvzg2KSvFK+k=;
        b=qLGFlnCLYm3hqNGixXOZvPZ8M9fEeDSVyv3fNWe5qMbqqPtuP5tshRn576JSU44qux
         rEt51ipq9gNbw2VtE5DjXCBtO2PolmKwcDrDIJEAZwQExCr2NrUXl5r/k2LJ0NZEYFR+
         JggSJSkqV9+tkBSXddfoYyM6Ag+NMnJWaQU7+X7c/e/CSa0KXtc3SxAO7k+MDcWuXfPA
         l+WH8/rmAdZzRnec0uJj+PkU7qBGY1Btb4InV0SHT/L1zrverLV7tQI6UMLR/mFGybHL
         rpicbfaV7VZG3rPjcDRP5Ubpfvg6sCmqg1816qQO8RUuliIrareIg2mnFKOn6hdTpgtQ
         eCtA==
X-Gm-Message-State: APjAAAUoPgxWQFSuJB6rx2CahIj/fU4loDkes5AHRAG3iMzgfEva+2CR
        6b+kJtQxwPQEAxMD/stIFdU=
X-Google-Smtp-Source: APXvYqzTxLcGdrsPPU3eOxGNGOQDIezsW+zj7fbitSQ99zChaY0XLbXSmEbAQNKB2NiqorjjmYKg/A==
X-Received: by 2002:a17:90a:fe04:: with SMTP id ck4mr27861326pjb.74.1569856965442;
        Mon, 30 Sep 2019 08:22:45 -0700 (PDT)
Received: from [172.26.125.239] ([2620:10d:c090:180::aa94])
        by smtp.gmail.com with ESMTPSA id w7sm12905416pjn.1.2019.09.30.08.22.44
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 30 Sep 2019 08:22:44 -0700 (PDT)
From:   "Jonathan Lemon" <jonathan.lemon@gmail.com>
To:     "Magnus Karlsson" <magnus.karlsson@intel.com>
Cc:     bjorn.topel@intel.com, ast@kernel.org, daniel@iogearbox.net,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH bpf] xsk: fix crash in poll when device does not support
 ndo_xsk_wakeup
Date:   Mon, 30 Sep 2019 08:22:43 -0700
X-Mailer: MailMate (1.12.5r5635)
Message-ID: <1CE08C6F-03BC-44C9-ACD3-F1C445C70B0C@gmail.com>
In-Reply-To: <1569850212-4035-1-git-send-email-magnus.karlsson@intel.com>
References: <1569850212-4035-1-git-send-email-magnus.karlsson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 30 Sep 2019, at 6:30, Magnus Karlsson wrote:

> Fixes a crash in poll() when an AF_XDP socket is opened in copy mode
> with the XDP_USE_NEED_WAKEUP flag set and the bound device does not
> have ndo_xsk_wakeup defined. Avoid trying to call the non-existing ndo
> and instead call the internal xsk sendmsg functionality to send
> packets in the same way (from the application's point of view) as
> calling sendmsg() in any mode or poll() in zero-copy mode would have
> done. The application should behave in the same way independent on if
> zero-copy mode or copy-mode is used.
>
> Fixes: 77cd0d7b3f25 ("xsk: add support for need_wakeup flag in AF_XDP 
> rings")
> Reported-by: syzbot+a5765ed8cdb1cca4d249@syzkaller.appspotmail.com
> Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>

Acked-by: Jonathan Lemon <jonathan.lemon@gmail.com>
