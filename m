Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 879A9DA210
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 01:22:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392175AbfJPXW2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 19:22:28 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:37859 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725970AbfJPXW2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 19:22:28 -0400
Received: by mail-lf1-f65.google.com with SMTP id w67so298420lff.4
        for <netdev@vger.kernel.org>; Wed, 16 Oct 2019 16:22:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=mjecSzPejQYaalbPR09N+D4rzebtX70neEvOMFMrPjM=;
        b=jQksH76hXXm+CjdyTzPWlxYkfjjcm1FqNADVzNNjVfXkulWBWVE5Tlge0+lpoYpR8U
         ms9M/oa/3V8cf9tbEu4Eo1s9GQm4/xrDE5IwXpRF7j6wnovrOV3EfgMsupss2fW5Hi1s
         JMzGvNH7GSHmGzaiWG/eX/lIHTJJPLVoNMid7gBjSmBhSUO77PPIFw6SGnaZL4BLsnJe
         kxGZ8eqOWrvNVWKATZnnjjDf7ueWUV8eLmuw/iHrXz2qlahkTjpH5AT5ol0TK/f1HB0/
         JztA6Il0Mq/oqgIxDyJIz9OV6EErabQOoZ/3wWQVHwZ7gEUepOQocvafVpQWgWkAAJef
         WhTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=mjecSzPejQYaalbPR09N+D4rzebtX70neEvOMFMrPjM=;
        b=as1r1TPrn4a+qldfU+CTcRbZtpfCId6lEo/50MAFvJwvNs5tZTalKs/V+wornIdGkZ
         kg307bGjD/20251CZZLx3c1t/yDrI4o7c3P7sNsSquGd6+Ve18sGG8sFWQBVJqWKoiME
         avq8sStczH4M5tal7Je3T9FkduOr1pCgmkuoHJq5nwcU5E5dQxDPe6GeLBMYNeb1Qaw4
         b6nXRoU7MpUwksEV3jbEhoIesBuGs3W61fG+bINIMIIP3vnzfIE+Ntel3l5dzlsczG7r
         nGJQl4mBf5f5978EDuFplVRNApfAVHUVqIwrtiuNTGAXby7eRPh+rmyEit7M2LW6FO/6
         PInA==
X-Gm-Message-State: APjAAAVmCdLD9AzmV24aKkqZOCruRyXgyOTKC8bEO0+uBD9yeR1H+42v
        pSk/6LaWUuOqbn47j20idOljHg==
X-Google-Smtp-Source: APXvYqzEay8w7Zvc16jpgSqkLos3NGdxinFDjPoFQ4x9UCUutdBvEzYkh0FltsERvk16ZD7HHckNDA==
X-Received: by 2002:a19:f013:: with SMTP id p19mr169048lfc.98.1571268146533;
        Wed, 16 Oct 2019 16:22:26 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id q5sm90434lfm.93.2019.10.16.16.22.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Oct 2019 16:22:25 -0700 (PDT)
Date:   Wed, 16 Oct 2019 16:22:18 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        oss-drivers@netronome.com,
        Stephen Hemminger <stephen@networkplumber.org>,
        kbuild test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Ben Hutchings <ben@decadent.org.uk>,
        Simon Horman <simon.horman@netronome.com>
Subject: Re: [PATCH net] net: netem: fix error path for corrupted GSO frames
Message-ID: <20191016162210.5f2a8256@cakuba.netronome.com>
In-Reply-To: <CAM_iQpXw7xBTGctD2oLdWGZHc+mpeUAMq5Z4AYvKSiw68e=5EQ@mail.gmail.com>
References: <20191016160050.27703-1-jakub.kicinski@netronome.com>
        <CAM_iQpXw7xBTGctD2oLdWGZHc+mpeUAMq5Z4AYvKSiw68e=5EQ@mail.gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 16 Oct 2019 15:42:28 -0700, Cong Wang wrote:
> > @@ -612,7 +613,7 @@ static int netem_enqueue(struct sk_buff *skb, struct Qdisc *sch,
> >                         }
> >                         segs = skb2;
> >                 }
> > -               qdisc_tree_reduce_backlog(sch, -nb, prev_len - len);
> > +               qdisc_tree_reduce_backlog(sch, !skb - nb, prev_len - len);  
> 
> Am I the only one has trouble to understand the expression
> "!skb - nb"?

The backward logic of qdisc_tree_reduce_backlog() always gives me a
pause :S  

Is 
-nb + !skb 
any better?

The point is we have a "credit" for the "head" skb we dropped. If we
didn't manage to queue any of the segs then the expression becomes 
...reduce_backlog(sch, 1, prev_len) basically cleaning up after the
head.

My knee jerk reaction was -> we should return DROP if head got dropped,
but that just makes things more nasty because we requeue the segs
directly into netem so if we say DROP we have to special case all the
segs which succeeded, that gets even more hairy.

I'm open to suggestions.. :(
