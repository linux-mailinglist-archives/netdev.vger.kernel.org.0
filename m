Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D38BE327510
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 00:08:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231164AbhB1XHi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Feb 2021 18:07:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230167AbhB1XHh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Feb 2021 18:07:37 -0500
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3F9CC06174A;
        Sun, 28 Feb 2021 15:06:56 -0800 (PST)
Received: by mail-lf1-x131.google.com with SMTP id e7so22512368lft.2;
        Sun, 28 Feb 2021 15:06:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=iyKrp7I82f3wYzsbQR/1Jeu1cFgJoa6hSbBVeuarAhw=;
        b=oHViD70z0SbOQqFxh5RghAauVZ/voXlwny9gh7JGx3X/bSiex+wP1sATNKpuhZI/IN
         SX0Mdgb11BtRrfhI2K8ooXb2vT/LTWPsIIzgGrcXd3GaBwpxLh+At5bk4wT66+eRJmf4
         VDAfmAB9qxb4dB5QRuFDy9eTS5M4Nwj179xJpTP5gs+LX+XpuROJmgX+iHb/WGH4Pgj0
         Ewt5fJ6aXh66PJdU7BVobFE46028SV8xeas9NF8t6hJ3ACDzZB971m8EZ+zc5HReRA6c
         IJgK83CiKkSOoLAlwuHBiE7NKkHDkOk0wuJvAZL7sTwK1qY8e8rYfREpjLyGuui1c24w
         R2Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=iyKrp7I82f3wYzsbQR/1Jeu1cFgJoa6hSbBVeuarAhw=;
        b=dJkwH6+IwcEc/NawBmR+Sn6Ql4F2mH1V2VhhuADtKOlPLbLyYX1pDzB4iU7n9DXBpe
         FfyQ++JxwBzTjpH5eY2p1vf8LZ0oEiOF2ocb+H/GGNCo04Vj7G8YghW4xl2K5/HNAnmL
         vGrF4DkQ4VEtpj4MyYTf27GlalNWs2QolCFWv7ax7L2gxKT3em1Zxcv0UOAB3nPMDWwj
         xQouBHLfz/GntEwRcO5Q+jUBGltoy7af1neVobkwwNdHgI3U6Q2sUM1WqW2qKKljKSmW
         d/V4DSoDbY2jSIla3aYOdN6z6pCJ84Wn4RwVSMEfkq5ju/2XvhgsXlV0BleCg8drY7T5
         UNIQ==
X-Gm-Message-State: AOAM533u8CR/UGassaVukAyjnzTNTN+Hp0xcFmT3vYJOG8xtj1WvLLqf
        LG+RhKL8UJeRaT+XKabhwnaFNBhXUtsrWd2ziqA=
X-Google-Smtp-Source: ABdhPJwtbA7bN5MLn3JH5hs5sFQbh2m5M/Xv/WbMEQz0B/AnkXbDnYdZULJwQmauC+SmDjuh/gR60Q==
X-Received: by 2002:ac2:484d:: with SMTP id 13mr3258103lfy.124.1614553615186;
        Sun, 28 Feb 2021 15:06:55 -0800 (PST)
Received: from pskrgag-home ([94.103.235.167])
        by smtp.gmail.com with ESMTPSA id i18sm2097297lfe.177.2021.02.28.15.06.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Feb 2021 15:06:54 -0800 (PST)
Message-ID: <b78123e002c7fde2bf3cfc1b708544ff605c4831.camel@gmail.com>
Subject: [PATCH v4] net/qrtr: fix __netdev_alloc_skb call
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     Alexander Lobakin <alobakin@pm.me>
Cc:     davem@davemloft.net, linmiaohe@huawei.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+80dccaee7c6630fa9dcf@syzkaller.appspotmail.com
Date:   Mon, 01 Mar 2021 02:06:44 +0300
In-Reply-To: <20210228201000.13606-1-alobakin@pm.me>
References: <20210227110306.13360-1-alobakin@pm.me>
         <20210227175114.28645-1-paskripkin@gmail.com>
         <20210228181440.1715-1-alobakin@pm.me>
         <47681a0b629ac0efb2ce0d92c3181db08e5ea3c8.camel@gmail.com>
         <20210228201000.13606-1-alobakin@pm.me>
Content-Type: text/plain
User-Agent: Evolution 3.36.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo=


