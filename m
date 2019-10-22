Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95020E0A74
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 19:19:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731703AbfJVRTp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 13:19:45 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:40315 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730433AbfJVRTo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 13:19:44 -0400
Received: by mail-lj1-f193.google.com with SMTP id u22so36386lji.7
        for <netdev@vger.kernel.org>; Tue, 22 Oct 2019 10:19:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=cy34QT92NHhuXVd0S9iPTc4eeCufEq/lJNlVwgrDWg0=;
        b=tEpsjhnXNsRzMFdAsi5Me5vtmMaSPKxbjyPby898vjwDTkOf6U4LzY66u49GwG4QxU
         PelGGK5wr/HkW0Vel+2/ab6Ro+WYh6lMvqELw1S19dch0gJnycxJkFTFS7qJ/0CbRwDp
         sS0FMnzQOyBKK+qQMbNnbfna88/YZZt46vKYn3UZ5CPC4RZdQ+MgHwWZ2JxseE2eFT1j
         cxE31qCc1oC8snuXaIae7fZMBEiVgQZhqc9zYn8CWTLNW1AV4MhL6/90fvnphP33G9EI
         jCZ8RU5+GWaky9PujnMjVTE9Uf3mk/Ci5xhAlEXOcUF/xARugV0TAjRGujTBAnYhurKv
         MZ0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=cy34QT92NHhuXVd0S9iPTc4eeCufEq/lJNlVwgrDWg0=;
        b=lYRMBefdAeJK2JpR11tf6mr/A1Ux2JmYMM30LDaIDMcooHmaxEImk7dX4inyHffMSY
         jqnSoKvmk0FfxN9/q1LTEPFiAfLOTaU7qMYnGrfYAczNYNzlgdehZqdhWIM1EeamvzOI
         hfiyGUCJfW2SCFoX/3YKBrEkJTYz1cxe8aZawGlpwr7cAJXiKhtYa9eRc2hsj+ScdPNH
         zFk5elVUMhSl0+M5YcH9XaJQ2Y4S53Z3yFDyTzJuD3dhuQYXgbzYHZnnR/452UyAOaQb
         FQma//9U75X9b7Ny4b/OsiOxuDaJDmEJsGRLXx5MOb/J1/+sL84dooI14WlExe0RVXCR
         NoaQ==
X-Gm-Message-State: APjAAAX2Ql/mz5Gp/p9BkHYc6FNaWm3T0z2QsTfKcxv4msjgf/di/jPD
        atxPNHl5I4iOAdkl0D5i527WP99F69o=
X-Google-Smtp-Source: APXvYqx2nMG9uV82zzuDAWW/sGyUPqp5AI2OI+UE3fPbmcfyRxRy2DzOxBhWNqFGs90SK1p+WXM+Qw==
X-Received: by 2002:a2e:97ca:: with SMTP id m10mr192469ljj.190.1571764782935;
        Tue, 22 Oct 2019 10:19:42 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id d24sm5173468lfl.65.2019.10.22.10.19.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Oct 2019 10:19:42 -0700 (PDT)
Date:   Tue, 22 Oct 2019 10:19:36 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Tejun Heo <tj@kernel.org>, "David S. Miller" <davem@davemloft.net>,
        netdev@vger.kernel.org, kernel-team@fb.com,
        linux-kernel@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>
Subject: Re: [PATCH] net: fix sk_page_frag() recursion from memory reclaim
Message-ID: <20191022101936.23759c14@cakuba.netronome.com>
In-Reply-To: <41874d3e-584c-437c-0110-83e001abf1b9@gmail.com>
References: <20191019170141.GQ18794@devbig004.ftw2.facebook.com>
        <dc6ff540-e7fc-695e-ed71-2bc0a92a0a9b@gmail.com>
        <20191019211856.GR18794@devbig004.ftw2.facebook.com>
        <41874d3e-584c-437c-0110-83e001abf1b9@gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 19 Oct 2019 14:25:57 -0700, Eric Dumazet wrote:
> On 10/19/19 2:18 PM, Tejun Heo wrote:
> 
> > Whatever works is fine by me.  gfpflags_allow_blocking() is clearer
> > than testing __GFP_DIRECT_RECLAIM directly tho.  Maybe a better way is
> > introducing a new gfpflags_ helper?  
> 
> Sounds good to me !

IIUC there will be a v2 with a new helper, dropping this from patchwork.
