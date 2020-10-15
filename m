Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A992728F2F1
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 15:12:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728231AbgJONME (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 09:12:04 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:30613 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726924AbgJONMD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Oct 2020 09:12:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602767522;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uAf/KQ6TAdYo1Wm4S00yfTFLig9CeJngAorlemy7WXc=;
        b=WPYTxfWpenyzRNvqTGJpp4hh3+b76u8dxA9SQy252rdGbZsOolOwDFJvc2OW46xbk7UNXJ
        5QMELvpuAhRPvLRZpOdtuWuYk58Oz3C/6OxPCapuaMGeL1VsU7aWiaaqTcH7sEHKm0TPbW
        F7a3e+j+V/0tGccnKWMQtG5F7TeeYHk=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-16-xfHIHqY3OaefcrZZcJGJZQ-1; Thu, 15 Oct 2020 09:12:01 -0400
X-MC-Unique: xfHIHqY3OaefcrZZcJGJZQ-1
Received: by mail-wr1-f70.google.com with SMTP id t17so1874614wrm.13
        for <netdev@vger.kernel.org>; Thu, 15 Oct 2020 06:12:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=uAf/KQ6TAdYo1Wm4S00yfTFLig9CeJngAorlemy7WXc=;
        b=W83QZQCd343StIRurdfQh8z4l2aUpZSSMWHYMU3CH68MviPkE3BjBB4Uqzqdqd9KTG
         RnRTq2CqWJrfHQUZp+XMp7VcJa/fOQsmFUL339hu6SF3qaqZgvqnmSW7f1xMJfqfeTfW
         Dl7QjY9CR42EXI7F6D+afod9TBoD1I+r42zzjEPvwqFi13P7bR7+wW9DK68zIR8tDWRK
         fFkK+Xv6AGssLfXET3vYw1X0dRHGwDi9MgT33AkloYTFl1+/2gTPzfhYWXLnw+UxH2cl
         IRt0jY7fDK67UEhv/y36RijNwGyQoz/0P8XxhVKU7uf+WJO18UuNc+NaasHKsUUT3Txh
         L8SQ==
X-Gm-Message-State: AOAM530F8/ffbbX7KiX4GQxRVQjaNMWa4VyTTwywaS+vjzCfJhnXr+mL
        Asv+qsLr8CN4obJ0/9seUpafuONOB+9iFoOmfuqtrulo1Amh5Y6uNomV4XjpTnAGiu2owcQ26I7
        UxhngBACl8zOnqcmK
X-Received: by 2002:a7b:c148:: with SMTP id z8mr3896326wmi.135.1602767519242;
        Thu, 15 Oct 2020 06:11:59 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyLn1GAiAp1rVzj+T97VT2N5UZGZv+k9R+BhLp1TRQ1j526UPewTS8smKxID+OGAzZGSt3Z4g==
X-Received: by 2002:a7b:c148:: with SMTP id z8mr3896295wmi.135.1602767519019;
        Thu, 15 Oct 2020 06:11:59 -0700 (PDT)
Received: from redhat.com (bzq-79-176-118-93.red.bezeqint.net. [79.176.118.93])
        by smtp.gmail.com with ESMTPSA id y7sm4331656wmg.40.2020.10.15.06.11.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2020 06:11:58 -0700 (PDT)
Date:   Thu, 15 Oct 2020 09:11:55 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     si-wei liu <si-wei.liu@oracle.com>, lingshan.zhu@intel.com,
        joao.m.martins@oracle.com, boris.ostrovsky@oracle.com,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: Re: [PATCH v3 2/2] vhost-vdpa: fix page pinning leakage in error path
Message-ID: <20201015091150-mutt-send-email-mst@kernel.org>
References: <1601701330-16837-1-git-send-email-si-wei.liu@oracle.com>
 <1601701330-16837-3-git-send-email-si-wei.liu@oracle.com>
 <574a64e3-8873-0639-fe32-248cb99204bc@redhat.com>
 <5F863B83.6030204@oracle.com>
 <835e79de-52d9-1d07-71dd-d9bee6b9f62e@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <835e79de-52d9-1d07-71dd-d9bee6b9f62e@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 15, 2020 at 02:15:32PM +0800, Jason Wang wrote:
> 
> On 2020/10/14 上午7:42, si-wei liu wrote:
> > > 
> > > 
> > > So what I suggest is to fix the pinning leakage first and do the
> > > possible optimization on top (which is still questionable to me).
> > OK. Unfortunately, this was picked and got merged in upstream. So I will
> > post a follow up patch set to 1) revert the commit to the original
> > __get_free_page() implementation, and 2) fix the accounting and leakage
> > on top. Will it be fine?
> 
> 
> Fine.
> 
> Thanks

Fine by me too.

