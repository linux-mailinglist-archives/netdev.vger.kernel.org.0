Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DEB9BA3A7A
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 17:37:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728146AbfH3Phe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 11:37:34 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:43667 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727940AbfH3Phe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Aug 2019 11:37:34 -0400
Received: by mail-pf1-f194.google.com with SMTP id v12so4865785pfn.10;
        Fri, 30 Aug 2019 08:37:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=J1+aQtXQNIaR051t0YQMFgBHKHuNGy2PCmvkkEIfppA=;
        b=rEGc2nwRRM6MwCrPk8Cx4X/sHeLm/4zqTp4G0MfMD4l0PoxJEpviyLoQsO+DK5xmG5
         DIUcXzMuuDHxvfm1XIUmVdQu84Edwx94oqBTjhMMgrAlW7NDJuRTv9LYQlJwEIY+g8gO
         FaZ2zUsST9QKNfY/5ca8szL8kJD/JJjhw8b3AFact6THoKXFA82WZDkxzOOpyNTFY/qY
         YcCNllVIHZvq3qKqeBMyYiXZexc6/IuVDGSUL6gc7RfrD69r9GQKEXkNXMPCVctqCAZa
         b+OCooNouVDvMGAosdN0LKEZWT4Xl9K53fjMCrVDbE745grFBL7NEj1UpNEvFsET/05x
         bHRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=J1+aQtXQNIaR051t0YQMFgBHKHuNGy2PCmvkkEIfppA=;
        b=OnPv6FQuDybT5+Z5GdZao18er8vwRWUxMjAQLPPvxnesoF8MG42C5mZs4pchaeKXEh
         OMqnbJDSlA7bJ0Rv6Do6+niJukmouaDED4WHAeySuu0ckZ7V4qvUZlTgeYDanoZ/iIKW
         NzaaO7BGP6LUv5Cbaerw66lQ4ywPRQbrtiNhL3fZ4b8VeqcHiZr+y8SpbyuFuQKASirK
         qKmDe2bTa/2IXmjy1dlQxveZJiotVTw2hAG3AHLJqjKgJXViQjTD25G5pXOAzKCUsGVb
         gNQxOivX5jd+ZqUv0Cs7ioPgMttyl+QIR/cu8nu2mEm0wmVsy+NFOMIV1F7Aohnz/MB4
         0TUw==
X-Gm-Message-State: APjAAAXh94ip1m9cB9S7Td6elx+evqHWvA+EM72kohMWT9s3lhh50G0t
        qEs68I10LQvZ4DErSae9g34=
X-Google-Smtp-Source: APXvYqzZe0JS0h4ppWeILzp7mHlppyvlyy8M20qzjGwQlZze3h2zOdaLaAUrNmzEqnyXpKozKCqTmw==
X-Received: by 2002:aa7:9d8d:: with SMTP id f13mr4489891pfq.196.1567179453940;
        Fri, 30 Aug 2019 08:37:33 -0700 (PDT)
Received: from [172.26.108.102] ([2620:10d:c090:180::7594])
        by smtp.gmail.com with ESMTPSA id k64sm9778889pge.65.2019.08.30.08.37.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 30 Aug 2019 08:37:33 -0700 (PDT)
From:   "Jonathan Lemon" <jonathan.lemon@gmail.com>
To:     "Kevin Laatz" <kevin.laatz@intel.com>
Cc:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        bjorn.topel@intel.com, magnus.karlsson@intel.com,
        jakub.kicinski@netronome.com, saeedm@mellanox.com,
        maximmi@mellanox.com, stephen@networkplumber.org,
        bruce.richardson@intel.com, ciara.loftus@intel.com,
        bpf@vger.kernel.org, intel-wired-lan@lists.osuosl.org
Subject: Re: [PATCH bpf-next v6 01/12] i40e: simplify Rx buffer recycle
Date:   Fri, 30 Aug 2019 08:37:31 -0700
X-Mailer: MailMate (1.12.5r5635)
Message-ID: <F8E0DEC3-B5A4-4546-A0E4-686877113546@gmail.com>
In-Reply-To: <20190827022531.15060-2-kevin.laatz@intel.com>
References: <20190822014427.49800-1-kevin.laatz@intel.com>
 <20190827022531.15060-1-kevin.laatz@intel.com>
 <20190827022531.15060-2-kevin.laatz@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 26 Aug 2019, at 19:25, Kevin Laatz wrote:

> Currently, the dma, addr and handle are modified when we reuse Rx buffers
> in zero-copy mode. However, this is not required as the inputs to the
> function are copies, not the original values themselves. As we use the
> copies within the function, we can use the original 'old_bi' values
> directly without having to mask and add the headroom.
>
> Signed-off-by: Kevin Laatz <kevin.laatz@intel.com>
Acked-by: Jonathan Lemon <jonathan.lemon@gmail.com>
