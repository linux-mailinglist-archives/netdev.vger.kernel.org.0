Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78431337087
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 11:53:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232464AbhCKKws (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 05:52:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232514AbhCKKwX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Mar 2021 05:52:23 -0500
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 986D5C061760
        for <netdev@vger.kernel.org>; Thu, 11 Mar 2021 02:52:22 -0800 (PST)
Received: by mail-lf1-x129.google.com with SMTP id p21so38944758lfu.11
        for <netdev@vger.kernel.org>; Thu, 11 Mar 2021 02:52:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=jrFpYE8nrsCGhuKH8Z1MPYCc2kyE8ltxYIbArqRBpcI=;
        b=Wr5VJhiUEj6Anx3jbX59PP65x6QGe2uBWrM0P4tR6Wm0PfJDVUYepic9Q8u5iNsm4A
         mj+pJT9XL3PKsaMS6TrYPbHXyt3x8xJpD5A1Xw5LW1WehV6ykMecFnSwWxcIz2dsjWX1
         09R959wyWkF93AxgczxAwHnKP39FjCFVAnOPk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=jrFpYE8nrsCGhuKH8Z1MPYCc2kyE8ltxYIbArqRBpcI=;
        b=Hu5q+zamPTN+LrY6N65FUwnmu6rBrCOKkcSUJj5g1Um96Mt/MMFmkHTi61tycBaZtC
         EcskFYFchmmRATa/7kIAnAnwxrQzZhi9kO83OogtTVAxZlcQzxshXtn32dSng6rkgPg3
         OEOU8dkNrrN+ZGQ6ThSzcoLNknS6c5rUSwPC4WZbi92YPSe2aG9Pr6NwzkFjnYW1/l5s
         HAY5OYmnL84FPYDWnqyPMSPN2WJ5mZcRWaIjsPLaHLQG/OHLvL/VCH9gM6ufoEVKpqNz
         jbyhqDy0nsptyqbkFfzcRrK/dgNQDvJpr1Apwfr3pQDa7/0bdESHq+R3SwkcB5Va7MF0
         Qxqw==
X-Gm-Message-State: AOAM5308lrcvH08CxegSRFrqrlXR5caMrfPyAB6CFE11W/qHVSrReUDi
        9EIi0x2ozSqvhbGs6s84n9S2Dg==
X-Google-Smtp-Source: ABdhPJwJG7epJTysKQknWKjrVh02iyyuC7bGeaUjoltxNezJvmLXyUugnGAIRTVuXd8583CYavmM1g==
X-Received: by 2002:a19:81d0:: with SMTP id c199mr1880836lfd.62.1615459940881;
        Thu, 11 Mar 2021 02:52:20 -0800 (PST)
Received: from cloudflare.com (79.184.34.53.ipv4.supernova.orange.pl. [79.184.34.53])
        by smtp.gmail.com with ESMTPSA id g21sm714496lfr.212.2021.03.11.02.52.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Mar 2021 02:52:20 -0800 (PST)
References: <20210310053222.41371-1-xiyou.wangcong@gmail.com>
 <20210310053222.41371-2-xiyou.wangcong@gmail.com>
User-agent: mu4e 1.1.0; emacs 27.1
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        duanxiongchun@bytedance.com, wangdongdong.6@bytedance.com,
        jiang.wang@bytedance.com, Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: Re: [Patch bpf-next v4 01/11] skmsg: lock ingress_skb when purging
In-reply-to: <20210310053222.41371-2-xiyou.wangcong@gmail.com>
Date:   Thu, 11 Mar 2021 11:52:18 +0100
Message-ID: <8735x23qu5.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 10, 2021 at 06:32 AM CET, Cong Wang wrote:
> From: Cong Wang <cong.wang@bytedance.com>
>
> Currently we purge the ingress_skb queue only when psock
> refcnt goes down to 0, so locking the queue is not necessary,
> but in order to be called during ->close, we have to lock it
> here.
>
> Cc: John Fastabend <john.fastabend@gmail.com>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Jakub Sitnicki <jakub@cloudflare.com>
> Cc: Lorenz Bauer <lmb@cloudflare.com>
> Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> ---

Acked-by: Jakub Sitnicki <jakub@cloudflare.com>
