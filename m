Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1563BBF408
	for <lists+netdev@lfdr.de>; Thu, 26 Sep 2019 15:26:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726876AbfIZN0b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Sep 2019 09:26:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51666 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726500AbfIZN0b (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Sep 2019 09:26:31 -0400
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com [209.85.160.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D8BB28E3C0
        for <netdev@vger.kernel.org>; Thu, 26 Sep 2019 13:26:30 +0000 (UTC)
Received: by mail-qt1-f197.google.com with SMTP id m19so2282708qtm.13
        for <netdev@vger.kernel.org>; Thu, 26 Sep 2019 06:26:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=W3FZ5vxqz4dbTcE/RzDr2BQP/Lbs5fzn9d+anVsPrI4=;
        b=UCUh5HLfqErwatlpkmU0/wd6ap+t0fF9NsTfubt8btB1hOxGWCbN4OAnAf963ULTH3
         GobVYGXC+ogbct9K+Z1AxfBk6rP0qQP9/IUeB5PH7sAnmvHyI1D2ZsDIPvX3g4LAlkWr
         4arkDrvm3NCIJBAbpHgJGg4+tOUOKbZXhAJUYZXzRfxnLyIKojN9XIB6I1A4YjvyBecr
         HfljszHY2AQAXJZivo79EvTUQpvK2LaaDfI4mDRcbZ6VeXBfKRtkDRG+mnsXEyC8AjyT
         OUWkNK0Dgx/+qcv1ri2F8TAZMrJyeNVD9XTyzpgg51bPBxssrUkwbAj7a9KXILuD8rxr
         S+jg==
X-Gm-Message-State: APjAAAU3KI+tyvtLJ36ZNMlL9rNH7xI2mZBqrrSvY15/mYzFWygKX+hS
        9CB1SFVIaRG+fq6fFvztlwSqkvAnuYk6rSfoqr9b7KOSE9WWeChWvewM/bY/Z0SQU3Rt+89IA8U
        rVk+GbicFSVk/nB9V
X-Received: by 2002:a05:620a:12b6:: with SMTP id x22mr3187483qki.495.1569504390224;
        Thu, 26 Sep 2019 06:26:30 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxOqinr5Q60U60VCr+5JVsP4K+bDRuObBU2H89+wefW4qdAMViXRd1NNdEtJnFrqVLkASlPsw==
X-Received: by 2002:a05:620a:12b6:: with SMTP id x22mr3187461qki.495.1569504389940;
        Thu, 26 Sep 2019 06:26:29 -0700 (PDT)
Received: from redhat.com (bzq-79-176-40-226.red.bezeqint.net. [79.176.40.226])
        by smtp.gmail.com with ESMTPSA id c12sm968131qkc.81.2019.09.26.06.26.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Sep 2019 06:26:28 -0700 (PDT)
Date:   Thu, 26 Sep 2019 09:26:22 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Tiwei Bie <tiwei.bie@intel.com>
Cc:     jasowang@redhat.com, alex.williamson@redhat.com,
        maxime.coquelin@redhat.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, dan.daly@intel.com,
        cunming.liang@intel.com, zhihong.wang@intel.com,
        lingshan.zhu@intel.com
Subject: Re: [PATCH] vhost: introduce mdev based hardware backend
Message-ID: <20190926091945-mutt-send-email-mst@kernel.org>
References: <20190926045427.4973-1-tiwei.bie@intel.com>
 <20190926042156-mutt-send-email-mst@kernel.org>
 <20190926131439.GA11652@___>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190926131439.GA11652@___>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 26, 2019 at 09:14:39PM +0800, Tiwei Bie wrote:
> > 4. Does device need to limit max ring size?
> > 5. Does device need to limit max number of queues?
> 
> I think so. It's helpful to have ioctls to report the max
> ring size and max number of queues.

Also, let's not repeat the vhost net mistakes, let's lock
everything to the order required by the virtio spec,
checking status bits at each step.
E.g.:
	set backend features
	set features
	detect and program vqs
	enable vqs
	enable driver

and check status at each step to force the correct order.
e.g. don't allow enabling vqs after driver ok, etc

-- 
MST
