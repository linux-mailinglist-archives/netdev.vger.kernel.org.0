Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7D2335E6EF
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 21:08:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232950AbhDMTI5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 15:08:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343838AbhDMTIv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 15:08:51 -0400
Received: from mail-qv1-xf2f.google.com (mail-qv1-xf2f.google.com [IPv6:2607:f8b0:4864:20::f2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BF5CC061574;
        Tue, 13 Apr 2021 12:08:31 -0700 (PDT)
Received: by mail-qv1-xf2f.google.com with SMTP id j3so8644928qvs.1;
        Tue, 13 Apr 2021 12:08:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=LdE+UQyPBir3qEoJ25yiHIhY36a9GrhFUDezW/crBk4=;
        b=BEK3HZeWPrQDeh+CQpY/A2Suo78Mt9YLm+JV/SteoPBcRqJQC7v0VsCNMosSzHucsc
         5JsdaE+HufhKwm6r1EmXlughUDl6JLpOmFD6PS1SPmh5FKzW1b2t4YEa/WdJP7/Vaj+v
         TvSFnwq+6PAqsZ62Y5cZCFkBfNGAeNJxF9NGOWJl8+kRkbbFeMfNs2VKGWhIKToOwElt
         qG11q2fIKtXIE/bEiG2fvlTBg7z7eYZQh+T8wKO0m7Swuhzona8gF9NJHvQ3G3kXRMK/
         GB98jjUK6oLImzAERXJ3KaJA6r9XrgCL8YR3g2GgefZQUOtc8zrBgvOqmPO69kDlSh3A
         7K7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=LdE+UQyPBir3qEoJ25yiHIhY36a9GrhFUDezW/crBk4=;
        b=H3nuYi+4zr3+am35DZQOCl6JZyWHnBteokAbviKQVqyGB7rruXyCcLABu+cE1Xftee
         4engbbNKT8y2Opx/yBuE+0wQf3CNj0YAYaDQG0nO3ucUbrNm/mZn4eNlvf2wd3qMdMiA
         3YMHv+g8Par5Rdc7E+V02FBzLtSr7wiWrvaoRdjjuITca+bomA/bFKqxoukcfncz9Imf
         nvu7/v2SHZpGHF/4f702Sf+Q2WLVMeQzmoITiy1BvkPTHXuZbcE8C2WFYJJugfOlszbL
         jGpQGaWc3w6UYrDmwkL/esPbl1oXLLi8pbnza4jCPBRsOwsK77BZ7mMDJ0yukp74Mr8C
         7bYA==
X-Gm-Message-State: AOAM5319dpHivxGT8DtTb0YjIuDG1zq/VybkMU4p84rzoeRDXtoH0Nea
        Vet6x/6a5A0Q/w3qqFt0cxFDkAOMm2txcggb
X-Google-Smtp-Source: ABdhPJzm61hO84yfhzWDbLnjvZ8nCJaWWv3w8LwgDu2a6LGoO7P0cTMNNDC+ALBOmi/spyLIBhwO2g==
X-Received: by 2002:a05:6214:19c4:: with SMTP id j4mr34361602qvc.27.1618340910256;
        Tue, 13 Apr 2021 12:08:30 -0700 (PDT)
Received: from horizon.localdomain ([177.220.174.149])
        by smtp.gmail.com with ESMTPSA id t6sm4792130qtq.83.2021.04.13.12.08.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Apr 2021 12:08:29 -0700 (PDT)
Received: by horizon.localdomain (Postfix, from userid 1000)
        id 7CAA2C0784; Tue, 13 Apr 2021 16:08:27 -0300 (-03)
Date:   Tue, 13 Apr 2021 16:08:27 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Or Cohen <orcohen@paloaltonetworks.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        vyasevich@gmail.com, nhorman@tuxdriver.com, davem@davemloft.net,
        kuba@kernel.org, linux-sctp@vger.kernel.org, lucien.xin@gmail.com,
        nmarkus@paloaltonetworks.com
Subject: Re: [PATCH v2] net/sctp: fix race condition in sctp_destroy_sock
Message-ID: <YHXsK3DzBTsO00lb@horizon.localdomain>
References: <20210413181031.27557-1-orcohen@paloaltonetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210413181031.27557-1-orcohen@paloaltonetworks.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 13, 2021 at 09:10:31PM +0300, Or Cohen wrote:
> If sctp_destroy_sock is called without sock_net(sk)->sctp.addr_wq_lock
> held and sp->do_auto_asconf is true, then an element is removed
> from the auto_asconf_splist without any proper locking.
> 
> This can happen in the following functions:
> 1. In sctp_accept, if sctp_sock_migrate fails.
> 2. In inet_create or inet6_create, if there is a bpf program
>    attached to BPF_CGROUP_INET_SOCK_CREATE which denies
>    creation of the sctp socket.
> 
> The bug is fixed by acquiring addr_wq_lock in sctp_destroy_sock
> instead of sctp_close.
> 
> This addresses CVE-2021-23133.
> 
> Reported-by: Or Cohen <orcohen@paloaltonetworks.com>
> Reviewed-by: Xin Long <lucien.xin@gmail.com>
> Fixes: 610236587600 ("bpf: Add new cgroup attach type to enable sock modifications")
> Signed-off-by: Or Cohen <orcohen@paloaltonetworks.com>

Thanks folks.
Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
