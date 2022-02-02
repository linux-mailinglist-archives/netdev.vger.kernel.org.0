Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D7264A7359
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 15:38:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344953AbiBBOiY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 09:38:24 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:30954 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229610AbiBBOiX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 09:38:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643812703;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SK05ivsB364EbcaunmsT44Ewqv2mgQRKL02/m8iznGI=;
        b=CyFVm1KzgpcAHsr6x0sIdWr2vnaHIDouGHQz2rkBsV+kzr3ITP0WGpyjscHatYT550FU/Y
        irwZM68AlxLuttgnsTEJzIXCPzk/TTZcEA2po1c1c2fVAsC5ky97Ksfr7TXQUfuTBaNdtS
        A0NkIp2sQ8K7HRq83GdVzpEFr5SgA50=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-643-UKOPLXBzPN2Dg3XmL3polA-1; Wed, 02 Feb 2022 09:38:22 -0500
X-MC-Unique: UKOPLXBzPN2Dg3XmL3polA-1
Received: by mail-ej1-f69.google.com with SMTP id l18-20020a1709063d3200b006a93f7d4941so8248181ejf.1
        for <netdev@vger.kernel.org>; Wed, 02 Feb 2022 06:38:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=SK05ivsB364EbcaunmsT44Ewqv2mgQRKL02/m8iznGI=;
        b=JSasLtJtxwJ9h1xAWLTXLL1uVocBQh1VXpi4Y+fy/GAGxZaM5+WzxJm3MvRbh7ucM9
         jO5vZUGWQDPq+XHiR28qxuN/0cdA6ozf7nxti3+pLLHehPGl5nnk3/TGSaZwpYoXYAuK
         r8WhQXUgtnZQhWfr+S8noeY9m0OhFdZH0nkRj4L8a/cdhU2Nmf2ER0t8KZdT3Sr/ILcC
         YaP/1SYkJRcvG/qPCgZlqRnKXhyhyYZQbEQfAKKFnU1Qi82fB81w6cnUr/wj9ElpEcJB
         D5cjpFIuITB7gqJynbsAAdMPSu6yQw5wer2Ol612OEP6WgzG6MkfMW2S97VnzEMlNtSd
         45bg==
X-Gm-Message-State: AOAM532f0yZ/SX4O2iE2Ws0CwNFOIEsgS9RwihGTIMcrcBAKNVLW/gVK
        T467F3Tw1XQ6GsNKfN44xFnvY+KQ4tTbJ6hMpJlgqNNlqtv4g9Qe3t3+oe9B0BuwCbaGVbeIjvF
        PTqDcaQQLjzzaoWAq
X-Received: by 2002:a05:6402:1c95:: with SMTP id cy21mr30192231edb.172.1643812701290;
        Wed, 02 Feb 2022 06:38:21 -0800 (PST)
X-Google-Smtp-Source: ABdhPJw4mKdbgbotGqwroG3gYviDkn9tixVksWzpb4CW2phdwr1s1PXz9GLSFxScu2Mtz4uclwNXUw==
X-Received: by 2002:a05:6402:1c95:: with SMTP id cy21mr30192215edb.172.1643812701126;
        Wed, 02 Feb 2022 06:38:21 -0800 (PST)
Received: from localhost (net-31-27-146-233.cust.vodafonedsl.it. [31.27.146.233])
        by smtp.gmail.com with ESMTPSA id g16sm2952886edr.101.2022.02.02.06.38.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Feb 2022 06:38:20 -0800 (PST)
Date:   Wed, 2 Feb 2022 15:38:16 +0100
From:   Andrea Claudi <aclaudi@redhat.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org, dsahern@gmail.com, markzhang@nvidia.com,
        leonro@nvidia.com
Subject: Re: [PATCH iproute2 1/3] lib/fs: fix memory leak in get_task_name()
Message-ID: <YfqXWG+hyjVtdwR6@tc2>
References: <cover.1643736038.git.aclaudi@redhat.com>
 <c7d57346ddc4d9eaaabc0f004911d038c95238af.1643736038.git.aclaudi@redhat.com>
 <20220201102712.1390ae4d@hermes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220201102712.1390ae4d@hermes.local>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 01, 2022 at 10:27:12AM -0800, Stephen Hemminger wrote:
> On Tue,  1 Feb 2022 18:39:24 +0100
> Andrea Claudi <aclaudi@redhat.com> wrote:
> 
> > +	if (fscanf(f, "%ms\n", &comm) != 1) {
> > +		free(comm);
> > +		return NULL;
> 
> This is still leaking the original comm.
>

Thanks Stephen, I missed the %m over there :(

> Why not change it to use a local variable for the path
> (avoid asprintf) and not reuse comm for both pathname
> and return value.
> 

Thanks for the suggestion. 

What about taking an extra-step and get rid of the %m too?
We can do something similar to the get_command_name() function so that
we don't need to use free in places where we use get_task_name().

