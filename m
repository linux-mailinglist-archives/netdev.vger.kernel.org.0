Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6576525A1B7
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 00:59:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726871AbgIAW7E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 18:59:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726091AbgIAW7D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 18:59:03 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B638C061244;
        Tue,  1 Sep 2020 15:59:03 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id f18so1707763pfa.10;
        Tue, 01 Sep 2020 15:59:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Wr253Z748sHRceyd8vWkesyq0DG6qp2MjOzIU3Wwnuk=;
        b=SEJiDRu/6YAyQpWAbKS4neNa3BdtYl/IKL5eFshYfp/Wiyth00krcPyWQ2ZbbNLxnx
         DxFzIJr3xawtY6DCNwrksGkgZ8jsBuYtYOK04kFApdyY3VgdZ/GV5mN+rQSxdv8UIqo/
         sAgg1qia9JRoHi609Kr5Y69+8Fx7HanXtBbJRDTW7EuOlhdHKKzEsBdEM57XPlVY7c+q
         m6d3h6Ic1Fvx7bvMwaAnFHW/2yPjV4YxBWqCm/PHwqcvPxhotHNDksUtth42q7veLslp
         yGT7F2QCRzViLR0WR/U7tz9IHIX9mEACUP2qyxlG0FIfzg0iIFKEEiMows2ZMdBAgWGR
         FJ5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Wr253Z748sHRceyd8vWkesyq0DG6qp2MjOzIU3Wwnuk=;
        b=DXx6q2p+TUFmBod4S5U2zPsmkSpSW8yG/qF1Weq6ZKoteWO7vGZDujiQVCjUwgPA6I
         TV/xKO4QH4EXyZeMnZms/nreuTSOaQ0K+g3hd1fpfiiXJwvsBXTWbgGUJlony6yR56Fi
         JgQfs4Ue5cY06Rff1Q+7hChnUlrubbIq0RBkGmBy72MeiD5GfMxGxshjlI9ueMWAIdBV
         cJk883vgzzHWB94TVJyAI/ey31jH9JPe3Z9igIWr36sP43+C810FQJur18RIkwyIU+pq
         uL3ZCafzQKJMtfEVUR6wvf4zsvW4dMJMCapK5bCibyEpqdk7JWSf25DfrQTThHJMmqOI
         LcYQ==
X-Gm-Message-State: AOAM533dfoDbWprm39+71nu9YYEtgwEkcZMRFju9/cthD35ZuWwsBHkb
        OjWPKATHd8hE1eS5Q1NQvhWN74RU2EJAwg==
X-Google-Smtp-Source: ABdhPJx8vSV8fCW15xCQqiM1kycSyZaJxBBEN2NciiKxlfyVvhkUa2V5lfzy8s8LLfgf/qzCylU+DQ==
X-Received: by 2002:a63:1252:: with SMTP id 18mr3524344pgs.246.1599001142459;
        Tue, 01 Sep 2020 15:59:02 -0700 (PDT)
Received: from thinkpad (104.36.148.139.aurocloud.com. [104.36.148.139])
        by smtp.gmail.com with ESMTPSA id w5sm3125624pgk.20.2020.09.01.15.59.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2020 15:59:02 -0700 (PDT)
Date:   Tue, 1 Sep 2020 15:59:44 -0700
From:   Rustam Kovhaev <rkovhaev@gmail.com>
To:     David Miller <davem@davemloft.net>
Cc:     kuba@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org
Subject: Re: [PATCH] veth: fix memory leak in veth_newlink()
Message-ID: <20200901225944.GB239544@thinkpad>
References: <20200830131336.275844-1-rkovhaev@gmail.com>
 <20200901.130127.236989626732311083.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200901.130127.236989626732311083.davem@davemloft.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 01, 2020 at 01:01:27PM -0700, David Miller wrote:
> From: Rustam Kovhaev <rkovhaev@gmail.com>
> Date: Sun, 30 Aug 2020 06:13:36 -0700
> 
> > when register_netdevice(dev) fails we should check whether struct
> > veth_rq has been allocated via ndo_init callback and free it, because,
> > depending on the code path, register_netdevice() might not call
> > priv_destructor() callback
> > 
> > Reported-and-tested-by: syzbot+59ef240dd8f0ed7598a8@syzkaller.appspotmail.com
> > Link: https://syzkaller.appspot.com/bug?extid=59ef240dd8f0ed7598a8
> > Signed-off-by: Rustam Kovhaev <rkovhaev@gmail.com>
> 
> I think I agree with Toshiaki here.  There is no reason why the
> rollback_registered() path of register_netdevice() should behave
> differently from the normal control flow.
> 
> Any code path that invokes ->ndo_uninit() should probably also
> invoke the priv destructor.
hi David, thank you for the review!

> 
> The question is why does the err_uninit: label of register_netdevice
> behave differently from rollback_registered()?  If there is a reason,
> it should be documented in a comment or similar.  If it is wrong,
> it should be corrected.
good question, that i do not know, i'll review it

