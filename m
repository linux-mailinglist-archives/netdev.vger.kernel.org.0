Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EEB6164326
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 09:56:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727063AbfGJH4M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 03:56:12 -0400
Received: from mail-vk1-f196.google.com ([209.85.221.196]:36682 "EHLO
        mail-vk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726132AbfGJH4L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jul 2019 03:56:11 -0400
Received: by mail-vk1-f196.google.com with SMTP id b69so293318vkb.3
        for <netdev@vger.kernel.org>; Wed, 10 Jul 2019 00:56:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-powerpc-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=YoC+z2/b09WrXH4lRir7hNFDRJ8+7/oQYY2CuVHQx1Y=;
        b=AWIpPHkq2+4lk5vaBQjk/aQmSEkXDJ2cFGgttIwHzX0Q+6RJ8CePT30S2PeOlx/mBn
         Ioa4hiHVpqnIIzVRduL0zggZjzDKLUWGKW+8pi2+scTUbwJ23oB+5/By4fn8/LqrEt4q
         xhuktd/lz60xlh8muMp/AeYgt46D46vXFRL0eFxZSOTR6hcfeA8UzzWXTYdWqD2Dm3hT
         JXzD10UTXAmK60AODrEE9NZc6XeMSTcv5JAJ634ZFY5NVcfsvEZDVd/Fhc5hNJXcu++0
         4SUwrmFD2gFkdjFExAlzXExId+0bbqxietdoUDYNTF/bYnoiqHz95YdkVfcwyd5IIzIN
         4u2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=YoC+z2/b09WrXH4lRir7hNFDRJ8+7/oQYY2CuVHQx1Y=;
        b=TjNFqJUe38v8HHDU/XLCd3vV7fmUNlbheKdQUSKI45S17HV8HPtx1/Q1iSOWi7dEfs
         NUtUdOxsOJDjclAn1gpG3VgdO1I0H5X3tMSNQusKfNaSlLbhouz6tqxTUYEIbC/CIsq5
         akwfW4wbJPmbzED/ErMx/nOFOrpxs9GhmXRqmNxkpsxUa5qKI7o71u17OyS1AyFPuVbT
         +bkeKEtwQ9Hde2DVxJhanVIblegbcPqsX0KooNDdEW9aftQhg3y/oJPs2FxalZ91z4s2
         f1zmzaoCce3fT94cft7GuKKyyYTE+qeuXoCXWNjWUO1W16pQjusha2LPDf2HzUFp9kGP
         yGEw==
X-Gm-Message-State: APjAAAU30g7gmLMQ7+J8FqeEGIcCrxgJZfc9nghXbhxErO2zT4OHz5Nn
        ecOeD4BJqRepIJJOtXCswsBPF5X9mDWUyxMCxxIqHQ==
X-Google-Smtp-Source: APXvYqxPX8Eosf5p0y3g5oPXjM98amD+W/fUs4D8mD81YKm2jN6PRgwNAw7eUdOWD++bHUdDQdykb4w+C0dzlQn+6Gc=
X-Received: by 2002:a1f:a887:: with SMTP id r129mr1194599vke.75.1562745370744;
 Wed, 10 Jul 2019 00:56:10 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ab0:2616:0:0:0:0:0 with HTTP; Wed, 10 Jul 2019 00:56:10
 -0700 (PDT)
X-Originating-IP: [5.35.70.113]
In-Reply-To: <20190709.125850.2133620086434576103.davem@davemloft.net>
References: <20190709114251.24662-1-dkirjanov@suse.com> <20190709.125850.2133620086434576103.davem@davemloft.net>
From:   Denis Kirjanov <kda@linux-powerpc.org>
Date:   Wed, 10 Jul 2019 10:56:10 +0300
Message-ID: <CAOJe8K2YWrZbHwX4FcKN4j0i=F3Lxmna6wvaZnDyqJe85w0Ykw@mail.gmail.com>
Subject: Re: [PATCH] vhost: fix null pointer dereference in vhost_del_umem_range
To:     David Miller <davem@davemloft.net>
Cc:     mst@redhat.com, jasowang@redhat.com, kvm@vger.kernel.org,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/9/19, David Miller <davem@davemloft.net> wrote:
> From: Denis Kirjanov <kda@linux-powerpc.org>
> Date: Tue,  9 Jul 2019 13:42:51 +0200
>
>> @@ -962,7 +962,8 @@ static void vhost_del_umem_range(struct vhost_umem
>> *umem,
>>
>>  	while ((node = vhost_umem_interval_tree_iter_first(&umem->umem_tree,
>>  							   start, end)))
>> -		vhost_umem_free(umem, node);
>> +		if (node)
>> +			vhost_umem_free(umem, node);
>
> If 'node' is NULL we will not be in the body of the loop as per
> the while() condition.

The patch is incorrect, please ignore

>
> How did you test this?
>
