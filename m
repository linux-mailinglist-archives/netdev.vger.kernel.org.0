Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1C26237A6
	for <lists+netdev@lfdr.de>; Mon, 20 May 2019 15:18:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391557AbfETMxE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 May 2019 08:53:04 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:34226 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391548AbfETMxD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 May 2019 08:53:03 -0400
Received: by mail-qt1-f194.google.com with SMTP id h1so16148100qtp.1
        for <netdev@vger.kernel.org>; Mon, 20 May 2019 05:53:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=FNAZcWqflA9IRxmObxU4/lbcnrS1uyVvwLBkqQKN8z8=;
        b=dX+8aRe3p33lu01SImk7+b/y+G19iBx74ngoUBKnx7xxnfI4JGOMGYAR9vGI5hNznj
         jKGzAZow81JShheoCtAOHBxPB91koRlpf1DiXMQCScLEpA2ZY0+BNKE2m+G+ppjYCoyB
         udpzRNiVWVdBy7I8QIpJmg2kJl+PkAM1s/mJHOe3fuxpn3VaqPXCjmNZKn/QiQOfyunb
         o9usnO0yZAOs29rBOQGNOIaFvjyFJlnfWbDonyobeordEOWQCe8VgFqqPHJgX67qWvSI
         b49Q5uqPc47y4Q8YRecx8N6B0jXNu+spZM3Rpvz+bKVobrlmhxN0mO03p/Uehj7lpaN9
         9RUg==
X-Gm-Message-State: APjAAAVXnr5l4op4dX28o5pSTsw94Us/yryXvvIRH9U2eP197CW0KFLs
        5MdazDnCaqlpI3iW4CRlqIo42Q==
X-Google-Smtp-Source: APXvYqxZc3EADFrIKvZtBidjDNyX7MfQHCtBgDMnAiOTyPCPBnueOwuGeJwhQyllR7iNwwTq6Wygtw==
X-Received: by 2002:ac8:2ea1:: with SMTP id h30mr21686178qta.333.1558356782974;
        Mon, 20 May 2019 05:53:02 -0700 (PDT)
Received: from redhat.com (pool-173-76-105-71.bstnma.fios.verizon.net. [173.76.105.71])
        by smtp.gmail.com with ESMTPSA id v3sm13052762qtc.97.2019.05.20.05.53.01
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 20 May 2019 05:53:01 -0700 (PDT)
Date:   Mon, 20 May 2019 08:52:59 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, stefanha@redhat.com
Subject: Re: [PATCH V2 0/4] Prevent vhost kthread from hogging CPU
Message-ID: <20190520085207-mutt-send-email-mst@kernel.org>
References: <1558067392-11740-1-git-send-email-jasowang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1558067392-11740-1-git-send-email-jasowang@redhat.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 17, 2019 at 12:29:48AM -0400, Jason Wang wrote:
> Hi:
> 
> This series try to prevent a guest triggerable CPU hogging through
> vhost kthread. This is done by introducing and checking the weight
> after each requrest. The patch has been tested with reproducer of
> vsock and virtio-net. Only compile test is done for vhost-scsi.
> 
> Please review.
> This addresses CVE-2019-3900.

OK I think we should clean this code some more but given
it's a CVE fix maybe it's best to do as a patch on top.

Acked-by: Michael S. Tsirkin <mst@redhat.com>

Dave do you want to merge this or should I?

> 
> Changs from V1:
> - fix user-ater-free in vosck patch
> 
> Jason Wang (4):
>   vhost: introduce vhost_exceeds_weight()
>   vhost_net: fix possible infinite loop
>   vhost: vsock: add weight support
>   vhost: scsi: add weight support
> 
>  drivers/vhost/net.c   | 41 ++++++++++++++---------------------------
>  drivers/vhost/scsi.c  | 21 ++++++++++++++-------
>  drivers/vhost/vhost.c | 20 +++++++++++++++++++-
>  drivers/vhost/vhost.h |  5 ++++-
>  drivers/vhost/vsock.c | 28 +++++++++++++++++++++-------
>  5 files changed, 72 insertions(+), 43 deletions(-)
> 
> -- 
> 1.8.3.1
