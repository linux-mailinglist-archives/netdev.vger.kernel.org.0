Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BF7729F731
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 22:53:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725825AbgJ2VxY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 17:53:24 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:41813 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725372AbgJ2VxW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 17:53:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604008401;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MyA/z9GmL/SPGNqgdbe5v/AJExbTh9xMmKh6pW57qzk=;
        b=AiXwD4xCV9cHssKJE4SpqfYxxJUr2an907Z4nMMY3ty9djFN5i90BoZcL0N82XVyGGaV5j
        PAXa0dR9EcLBHK8bFAWesCRcb9C6Mzg2mH8zP+MTWjPufNVYkWYFJQcUzIBJkJ4N+tESUA
        LFd0yhbZgGncF3ffjTd6G50n0j1/Pvw=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-557-oqURfZUIPN2Vo6hNHxoEkw-1; Thu, 29 Oct 2020 17:53:17 -0400
X-MC-Unique: oqURfZUIPN2Vo6hNHxoEkw-1
Received: by mail-wr1-f69.google.com with SMTP id q15so1819446wrw.8
        for <netdev@vger.kernel.org>; Thu, 29 Oct 2020 14:53:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=MyA/z9GmL/SPGNqgdbe5v/AJExbTh9xMmKh6pW57qzk=;
        b=to6FCbUrmBdoQbD/MAA+luYw0f7B5bWCC3PczZYu9Dp3whqONHyGbJvaGav3e43gx1
         lXbZMv4DFUUnpvx+zwbWIhr+s1Rx8nGo30By+UBSzgxbFgkix1yYYOHd/UHpuNq7t+1q
         SlrV6deQYZWbDBYqN9tbCFM8GWQVOukwZ823J53DuXqL5sM+iJh/o63qq6uBs177iBk6
         /YbHx9yT8NlrJdFs7DskxptdFCVghtwgnpVFEbf4G4AvQYYfKfwxOUX3bwikvrwh3JWH
         gyT0qMkIK1sEZhOeBQilW2Xd5QjEuO/f+zUlhLN68QqjKW4LIAc3O3WiwPTwuXl/EZH8
         Gcww==
X-Gm-Message-State: AOAM531mvapv0cAt3X3gmcTV1M/f6bxnv2y6dGxnzGyy+0ICez2vpXVK
        h0y1NszYzDBr68qAb9hANs9KyvBh13n812IyR8jRwTfiOGQdHPXtGg9//xySJsp1qSYKoSusZMj
        b/R04wZZlaLV+52Sc
X-Received: by 2002:a7b:cc8b:: with SMTP id p11mr1392923wma.100.1604008395966;
        Thu, 29 Oct 2020 14:53:15 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzOb9jejDagKN2otqeV1zFSG0/6+d0FSNPfIRhJooGnxcFENInAFKxKGTfRGns8rrnMa1b1mA==
X-Received: by 2002:a7b:cc8b:: with SMTP id p11mr1392912wma.100.1604008395829;
        Thu, 29 Oct 2020 14:53:15 -0700 (PDT)
Received: from redhat.com (bzq-79-176-118-93.red.bezeqint.net. [79.176.118.93])
        by smtp.gmail.com with ESMTPSA id v67sm2022382wma.17.2020.10.29.14.53.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2020 14:53:14 -0700 (PDT)
Date:   Thu, 29 Oct 2020 17:53:12 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     si-wei liu <si-wei.liu@oracle.com>
Cc:     Jason Wang <jasowang@redhat.com>, lingshan.zhu@intel.com,
        joao.m.martins@oracle.com, boris.ostrovsky@oracle.com,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: Re: [PATCH v3 2/2] vhost-vdpa: fix page pinning leakage in error path
Message-ID: <20201029175305-mutt-send-email-mst@kernel.org>
References: <1601701330-16837-1-git-send-email-si-wei.liu@oracle.com>
 <1601701330-16837-3-git-send-email-si-wei.liu@oracle.com>
 <574a64e3-8873-0639-fe32-248cb99204bc@redhat.com>
 <5F863B83.6030204@oracle.com>
 <835e79de-52d9-1d07-71dd-d9bee6b9f62e@redhat.com>
 <20201015091150-mutt-send-email-mst@kernel.org>
 <5F88AE4A.9030300@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5F88AE4A.9030300@oracle.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 15, 2020 at 01:17:14PM -0700, si-wei liu wrote:
> 
> On 10/15/2020 6:11 AM, Michael S. Tsirkin wrote:
> > On Thu, Oct 15, 2020 at 02:15:32PM +0800, Jason Wang wrote:
> > > On 2020/10/14 上午7:42, si-wei liu wrote:
> > > > > 
> > > > > So what I suggest is to fix the pinning leakage first and do the
> > > > > possible optimization on top (which is still questionable to me).
> > > > OK. Unfortunately, this was picked and got merged in upstream. So I will
> > > > post a follow up patch set to 1) revert the commit to the original
> > > > __get_free_page() implementation, and 2) fix the accounting and leakage
> > > > on top. Will it be fine?
> > > 
> > > Fine.
> > > 
> > > Thanks
> > Fine by me too.
> > 
> Thanks, Michael & Jason. I will post the fix shortly. Stay tuned.
> 
> -Siwei

did I miss the patch?

