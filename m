Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 890523AC4DE
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 09:20:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231923AbhFRHWl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 03:22:41 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:27259 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233092AbhFRHWj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Jun 2021 03:22:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624000828;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=08bKtYLw8+WJMSJXFwmWg9TmqP7htBCNATjR/bZl300=;
        b=DV3saigLbsI8fdeBhP/NRgFbSEpD84JUeRHA4rNeQ9nfVItpnOtCCX0hCosJmEo8maLtCH
        jbMYp2T0/aP85rq9SePyrXX4wIFvMaYVGiEfAuO5V3VnglFnO1Hmw08ptQtI21nSwo3ysq
        hM4R9p0DvM3AwEJlQgkZy+SS/T+xXHk=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-267-l8SWlCi5OeW5eXlBnTv1sg-1; Fri, 18 Jun 2021 03:20:27 -0400
X-MC-Unique: l8SWlCi5OeW5eXlBnTv1sg-1
Received: by mail-pg1-f199.google.com with SMTP id d8-20020a6558880000b02902225e17c66bso5403546pgu.23
        for <netdev@vger.kernel.org>; Fri, 18 Jun 2021 00:20:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=08bKtYLw8+WJMSJXFwmWg9TmqP7htBCNATjR/bZl300=;
        b=ZgyDui+GmOAcSA8i+k3tE74xs7Lz9XMi9Qo0oedpTFNvtOlkzyNwxxkfIVH8P1PpV/
         du2ICoZS0Ctm+zJPAyJPVxGT98Yby1maCzSeqnOA4nr3rjWTjRuza7p0aVMQpN+9zA6c
         hZ5fOzkEEC1HDWC9+vinMoslnq1qjDW+tKRCybovGPRKXim2GaC94R6+/ZOzBmhSRyiM
         +P7DZf+yaAmEVPRDW8C/K9S5IW73F9xp0IoFkgcB/MfBsQDEWOJ5ZEMtFb0UCBI57Ho6
         pG1/GszS9rux445HEDFOTUerYcSVPmZhyrbWySQCR2vMIXVj1q2Dv7OzkTUQadRgy4s2
         oUcQ==
X-Gm-Message-State: AOAM531qMRj3dPjETbnoh1MrgDM2ZuOKKh7BjMrLpZROH9CVmP5TPqGU
        zR9HH57rBAZ+yypwWGHvlaKfeTl27QC+8a6Kf4juMp7DL7Ip7NqluIiIgNQjbWYI+sMvRFXSsga
        qIo8qXdZX7b4PuYSFTjBVKCjqROqDKf9HWunj4gpuKwIKjBfHO+SCZgrjzz1qxPvHfmGG
X-Received: by 2002:a63:5d5:: with SMTP id 204mr8666311pgf.72.1624000826300;
        Fri, 18 Jun 2021 00:20:26 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzEQkh9qhMUesoxoT0WlU7iHzOuiibkI62nhu2NHrn8HyNbptwaeYz6rc1kpnZvt7mx+SI2wg==
X-Received: by 2002:a63:5d5:: with SMTP id 204mr8666288pgf.72.1624000826020;
        Fri, 18 Jun 2021 00:20:26 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id d92sm7246815pjk.38.2021.06.18.00.20.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Jun 2021 00:20:25 -0700 (PDT)
Subject: Re: [PATCH] vhost-vdpa: fix bug-"v->vqs" and "v" don't free
To:     Cai Huoqing <caihuoqing@baidu.com>, mst@redhat.com
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org
References: <20210618065307.183-1-caihuoqing@baidu.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <5f046ae5-2a1a-e843-bcae-f16ac0167c0e@redhat.com>
Date:   Fri, 18 Jun 2021 15:20:11 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210618065307.183-1-caihuoqing@baidu.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


ÔÚ 2021/6/18 ÏÂÎç2:53, Cai Huoqing Ð´µÀ:
> "v->vqs" and "v" don't free when "cdev_device_add" returns error
>
> Signed-off-by: Cai Huoqing <caihuoqing@baidu.com>
> ---
>   drivers/vhost/vdpa.c | 2 ++
>   1 file changed, 2 insertions(+)
>
> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> index fb41db3da611..6e5d5df5ee70 100644
> --- a/drivers/vhost/vdpa.c
> +++ b/drivers/vhost/vdpa.c
> @@ -1065,6 +1065,8 @@ static int vhost_vdpa_probe(struct vdpa_device *vdpa)
>   
>   err:
>          put_device(&v->dev);
> +       kfree(v->vqs);
> +       kfree(v);


Isn't this the charge of vhost_vdpa_release_dev()?

Thanks


>          return r;
>   }
>   

