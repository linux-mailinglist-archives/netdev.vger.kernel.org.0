Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36801D1FA6
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 06:29:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726513AbfJJE3u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 00:29:50 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:38430 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725971AbfJJE3u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 00:29:50 -0400
Received: by mail-pl1-f196.google.com with SMTP id w8so2134542plq.5
        for <netdev@vger.kernel.org>; Wed, 09 Oct 2019 21:29:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=EgruT0pfyLqpy4bc3AX859mqf8RIbemrxdd7wh+jLJs=;
        b=w9i6bavX8QN1fyG3pQYfrjbSbtLUZu77zt4qdUtQU7Aw88ZzXky+qRKThNA3soW+aU
         YEo8+0tqCvpmMEaV+I6W+UwHE9cxrh3Pposjsf0wNYJFR+CYGfPOZpeG9IdhmJmd5IxR
         IP9C6vF1Shnv98AmWZbAnOmASiatzI3Lrjdocl9qwYEk4y/mPpuUerarjtE4iote/L2l
         s4RttDka5pzQrJanE4RSsupYwo5/cSsswS6YjEvqFISMHUWu8PpVlJnO+UdEcAc90Tax
         VHAk5nGeEjhZvS8Q0tu/OddDlObpTiN8nLrZlDxjnLN9ns7s3mxdFdCGzD0ioZAycQyY
         TnQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=EgruT0pfyLqpy4bc3AX859mqf8RIbemrxdd7wh+jLJs=;
        b=SIGd7a+upsJ/lJImfcVOD0ynQfF7ZdnO4sW3/9lo5/sLCWsgnAZWMUbqwHs/0HM1Q/
         jz4Qx3xc2B9vyZAq5+UQwwyrMwSggAeVMHXhKtvf2RHUG+1bvJFMkoCrtXE1GzOkau9F
         117tXjGUJPMSL+6LcwbEO7rDnqNua/417J+DkoGvDlKH+HCPP4Z8RygpazAyGITZhoAb
         UPepaA52UHFjqfoqmVC6Gx3WheSw4ZHzFRD+JAfG7neqdMGNidowNEyS0RpuUg4/HGap
         Yx8769ginPVHG5w/Rq63K46sN6p3ajJs9fMAGUwsmYW+PopB0s8CQXX22FmFLusAOHso
         jOBQ==
X-Gm-Message-State: APjAAAU1cSUmgDqtw0HJ49g8anthqdFPayjVqXWQZFME1RrQdMJKcth9
        Gu2wBiJD+02dRegFm/S3dW8+Xg==
X-Google-Smtp-Source: APXvYqwCCvD7IuDky90CEeqB4y9QZZLyyEBjbUZh30881Psk8i0kIXnIRdanB0xR9FmMDPbL2isbTg==
X-Received: by 2002:a17:902:bf45:: with SMTP id u5mr7260260pls.62.1570681789712;
        Wed, 09 Oct 2019 21:29:49 -0700 (PDT)
Received: from cakuba.netronome.com (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id 127sm5124046pfw.6.2019.10.09.21.29.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Oct 2019 21:29:49 -0700 (PDT)
Date:   Wed, 9 Oct 2019 21:29:36 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Zhang Yu <zhangyu31@baidu.com>, Wang Li <wangli39@baidu.com>,
        Li RongQing <lirongqing@baidu.com>,
        Jason Wang <jasowang@redhat.com>
Subject: Re: [PATCH net] tun: remove possible false sharing in
 tun_flow_update()
Message-ID: <20191009212936.29c2068e@cakuba.netronome.com>
In-Reply-To: <20191009162002.19360-1-edumazet@google.com>
References: <20191009162002.19360-1-edumazet@google.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  9 Oct 2019 09:20:02 -0700, Eric Dumazet wrote:
> As mentioned in https://github.com/google/ktsan/wiki/READ_ONCE-and-WRITE_ONCE#it-may-improve-performance
> a C compiler can legally transform
> 
> if (e->queue_index != queue_index)
> 	e->queue_index = queue_index;
> 
> to :
> 
> 	e->queue_index = queue_index;
> 
> Note that the code using jiffies has no issue, since jiffies
> has volatile attribute.
> 
> if (e->updated != jiffies)
>     e->updated = jiffies;
> 
> Fixes: 83b1bc122cab ("tun: align write-heavy flow entry members to a cache line")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Zhang Yu <zhangyu31@baidu.com>
> Cc: Wang Li <wangli39@baidu.com>
> Cc: Li RongQing <lirongqing@baidu.com>
> Cc: Jason Wang <jasowang@redhat.com>

Applied, same story with stable, thanks!
