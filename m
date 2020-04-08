Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3ED441A1C02
	for <lists+netdev@lfdr.de>; Wed,  8 Apr 2020 08:44:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726575AbgDHGo4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Apr 2020 02:44:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:52972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725763AbgDHGo4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Apr 2020 02:44:56 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D9161206A1;
        Wed,  8 Apr 2020 06:44:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586328295;
        bh=3ZTezOavjUBqG8/Hb5MhazLE5LNFV48OMgQdbIDRDQY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=h80RXm9ZhIxo6FaJhpuEgsIHJdFyQBc5BJxU1INOXKA8YzGLpofZ+OLwPE4MvW4Im
         1PHiXWejsIPaFaY2SGHysSrGi9arSrm+EVDPx3khRDfWlQRylo24+S4+aXU8n48v7B
         3V6zhhr2aMfnCEu4fNJ9KPvh7aFrLs1x+ULsdfqA=
Date:   Wed, 8 Apr 2020 09:44:51 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Ka-Cheong Poon <ka-cheong.poon@oracle.com>
Cc:     netdev@vger.kernel.org, santosh.shilimkar@oracle.com,
        davem@davemloft.net, rds-devel@oss.oracle.com,
        sironhide0null@gmail.com
Subject: Re: [PATCH net 1/2] net/rds: Replace direct refcount_inc() by inline
 function
Message-ID: <20200408064451.GE3310@unreal>
References: <4b96ea99c3f0ccd5cc0683a5c944a1c4da41cc38.1586275373.git.ka-cheong.poon@oracle.com>
 <20200407184809.GP80989@unreal>
 <5f32ad26-5e3c-d5e2-6d04-6529fbe7fef0@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5f32ad26-5e3c-d5e2-6d04-6529fbe7fef0@oracle.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 08, 2020 at 12:15:51PM +0800, Ka-Cheong Poon wrote:
> On 4/8/20 2:48 AM, Leon Romanovsky wrote:
> > On Tue, Apr 07, 2020 at 09:08:01AM -0700, Ka-Cheong Poon wrote:
> > > Added rds_ib_dev_get() and rds_mr_get() to improve code readability.
> >
> > It is very hard to agree with this sentence.
> > Hiding basic kernel primitives is very rare will improve code readability.
> > It is definitely not the case here.
>
>
> This is to match the rds_ib_dev_put() and rds_mr_put() functions.
> Isn't it natural to have a pair of *_put()/*_get() functions?

Ohhh, thank you for pointing that. It is great example why hiding basic
primitives is really bad idea.

123 void rds_ib_dev_put(struct rds_ib_device *rds_ibdev)
124 {
125         BUG_ON(refcount_read(&rds_ibdev->refcount) == 0);
            ^^^^^^ no to this
126         if (refcount_dec_and_test(&rds_ibdev->refcount))
127                 queue_work(rds_wq, &rds_ibdev->free_work);
128 }

....

300         rds_ib_dev_put(rds_ibdev);
301         rds_ib_dev_put(rds_ibdev);

Double put -> you wrongly initialized/used refcount.

So instead of hiding refcount_inc(), I would say delete your *_put() variants,
fix reference counting and convert rds_mr_put() to be normal kref object
instead of current implementation. Which does exactly the same like your
custom *_put()/_get(), but better and with less errors.

Thanks
