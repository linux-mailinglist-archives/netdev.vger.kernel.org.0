Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1675E1EB969
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 12:18:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728114AbgFBKRv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 06:17:51 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:30816 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728087AbgFBKRe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jun 2020 06:17:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591093052;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=m8flul9T5/INbLuHOQ1wE5MsczYdkAsRCFisLMaoyM8=;
        b=esdb+r6KH4ihRNUKwDg4x7jtXBcyg8yMFWl6/jcDt5KrKLcKSOQse7jd/2PsxAFGXZtY55
        eLo1J5EqPSaiQmm07I2YhkM1b8Z4Fa6D3SsU7j1BjuWmCS97omls9w9zLxGsU9NfRPoiCh
        14TF8h2t5yaFYGLKeVaIJnKyiC2regc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-196-_gVI1e6lPeGjgn2AI4D0lw-1; Tue, 02 Jun 2020 06:17:07 -0400
X-MC-Unique: _gVI1e6lPeGjgn2AI4D0lw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4AC751030982;
        Tue,  2 Jun 2020 10:17:05 +0000 (UTC)
Received: from [10.72.12.83] (ovpn-12-83.pek2.redhat.com [10.72.12.83])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5E9C8100164D;
        Tue,  2 Jun 2020 10:16:54 +0000 (UTC)
Subject: Re: [PATCH] vdpa: bypass waking up vhost_woker for vdpa vq kick
To:     Dan Carpenter <dan.carpenter@oracle.com>, kbuild@lists.01.org,
        Zhu Lingshan <lingshan.zhu@intel.com>, mst@redhat.com,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     lkp@intel.com, kbuild-all@lists.01.org, lulu@redhat.com,
        dan.daly@intel.com, cunming.liang@intel.com
References: <20200602094203.GU30374@kadam>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <b8ccbccf-f667-8d15-8de2-b87da5f51ec3@redhat.com>
Date:   Tue, 2 Jun 2020 18:16:50 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200602094203.GU30374@kadam>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/6/2 下午5:42, Dan Carpenter wrote:
> Hi Zhu,
>
> url:    https://github.com/0day-ci/linux/commits/Zhu-Lingshan/vdpa-bypass-waking-up-vhost_woker-for-vdpa-vq-kick/20200526-133819
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git linux-next
> config: x86_64-randconfig-m001-20200529 (attached as .config)
> compiler: gcc-9 (Debian 9.3.0-13) 9.3.0
>
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kbuild test robot <lkp@intel.com>
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
>
> smatch warnings:
> drivers/vhost/vdpa.c:348 vhost_vdpa_set_vring_kick() error: uninitialized symbol 'r'.
>
> # https://github.com/0day-ci/linux/commit/a84ddbf1ef29f18aafb2bb8a93bcedd4a29a967d
> git remote add linux-review https://github.com/0day-ci/linux
> git remote update linux-review
> git checkout a84ddbf1ef29f18aafb2bb8a93bcedd4a29a967d
> vim +/r +348 drivers/vhost/vdpa.c
>
> a84ddbf1ef29f1 Zhu Lingshan 2020-05-26  316  static long vhost_vdpa_set_vring_kick(struct vhost_virtqueue *vq,
> a84ddbf1ef29f1 Zhu Lingshan 2020-05-26  317  				      void __user *argp)
> a84ddbf1ef29f1 Zhu Lingshan 2020-05-26  318  {
> a84ddbf1ef29f1 Zhu Lingshan 2020-05-26  319  	bool pollstart = false, pollstop = false;
> a84ddbf1ef29f1 Zhu Lingshan 2020-05-26  320  	struct file *eventfp, *filep = NULL;
> a84ddbf1ef29f1 Zhu Lingshan 2020-05-26  321  	struct vhost_vring_file f;
> a84ddbf1ef29f1 Zhu Lingshan 2020-05-26  322  	long r;
> a84ddbf1ef29f1 Zhu Lingshan 2020-05-26  323
> a84ddbf1ef29f1 Zhu Lingshan 2020-05-26  324  	if (copy_from_user(&f, argp, sizeof(f)))
> a84ddbf1ef29f1 Zhu Lingshan 2020-05-26  325  		return -EFAULT;
> a84ddbf1ef29f1 Zhu Lingshan 2020-05-26  326
> a84ddbf1ef29f1 Zhu Lingshan 2020-05-26  327  	eventfp = f.fd == -1 ? NULL : eventfd_fget(f.fd);
> a84ddbf1ef29f1 Zhu Lingshan 2020-05-26  328  	if (IS_ERR(eventfp)) {
> a84ddbf1ef29f1 Zhu Lingshan 2020-05-26  329  		r = PTR_ERR(eventfp);
> a84ddbf1ef29f1 Zhu Lingshan 2020-05-26  330  		return r;
> a84ddbf1ef29f1 Zhu Lingshan 2020-05-26  331  	}
> a84ddbf1ef29f1 Zhu Lingshan 2020-05-26  332
> a84ddbf1ef29f1 Zhu Lingshan 2020-05-26  333  	if (eventfp != vq->kick) {
> a84ddbf1ef29f1 Zhu Lingshan 2020-05-26  334  		pollstop = (filep = vq->kick) != NULL;
> a84ddbf1ef29f1 Zhu Lingshan 2020-05-26  335  		pollstart = (vq->kick = eventfp) != NULL;
> a84ddbf1ef29f1 Zhu Lingshan 2020-05-26  336  	} else
> a84ddbf1ef29f1 Zhu Lingshan 2020-05-26  337  		filep = eventfp;
> a84ddbf1ef29f1 Zhu Lingshan 2020-05-26  338
> a84ddbf1ef29f1 Zhu Lingshan 2020-05-26  339  	if (pollstop && vq->handle_kick)
> a84ddbf1ef29f1 Zhu Lingshan 2020-05-26  340  		vhost_vdpa_poll_stop(vq);
> a84ddbf1ef29f1 Zhu Lingshan 2020-05-26  341
> a84ddbf1ef29f1 Zhu Lingshan 2020-05-26  342  	if (filep)
> a84ddbf1ef29f1 Zhu Lingshan 2020-05-26  343  		fput(filep);
> a84ddbf1ef29f1 Zhu Lingshan 2020-05-26  344
> a84ddbf1ef29f1 Zhu Lingshan 2020-05-26  345  	if (pollstart && vq->handle_kick)
> a84ddbf1ef29f1 Zhu Lingshan 2020-05-26  346  		r = vhost_vdpa_poll_start(vq);
>
> "r" not initialized on else path.
>
> a84ddbf1ef29f1 Zhu Lingshan 2020-05-26  347
> a84ddbf1ef29f1 Zhu Lingshan 2020-05-26 @348  	return r;
> a84ddbf1ef29f1 Zhu Lingshan 2020-05-26  349  }


Will fix.

Thanks


> ---
> 0-DAY CI Kernel Test Service, Intel Corporation
> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

