Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 134B4858C3
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 05:48:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389749AbfHHDsN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Aug 2019 23:48:13 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:44683 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727950AbfHHDsM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Aug 2019 23:48:12 -0400
Received: by mail-ot1-f68.google.com with SMTP id b7so62904457otl.11;
        Wed, 07 Aug 2019 20:48:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/VvNaj/wtNAj4hKnQgUonNXIEppB0e4o77A5BHU4ets=;
        b=oFgFpikvDc0LWHCtOrIugnKh9+eXAJVHHOe4wklWYmEDIMxXfijLbgBnwiTvXiIVlk
         Jy1Ou8DeMrrjB8dTWDhTXAZEgNDJqZ63tYjKxq4yzkcN57krzxBQtt8HI5OiqP13yNcC
         PTQ/3S62lHM3mAYwndCc8Grk8/THRDreZUf2a/b0HbHxfirQUiOKrcm1/6lVtF172WDp
         ShwJgFtlu3dr0eIt1LbMkFfMOIQvkH1td9BeHWROPViUKRxJQcoYeKiukHkLL5+5qMpX
         73c3tPDkbsXGLXG92Ffxb3T1Ek0pLZm+RYBDW4YAwjJVdaslCQ+h4DqVslQBbfrmwNOZ
         sCsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/VvNaj/wtNAj4hKnQgUonNXIEppB0e4o77A5BHU4ets=;
        b=noNhQgLmJWCh3cC347eZCYgfePOpWmxhpXQ25eyLJmfkN5Lb2pnOEola4cx2oFZahr
         5MncGamq4rkBfcpt7H1o+Sdi3Q9QFojLA9LKRqV2en5GkzPlmx4xGkVnb6DmNraTDzkz
         FSzQ4H+rYAfrKcu+5BEbk2QwNpYx4M3uSCzGZZA8VMi0TOmt3j20Jvfl1/JKiVLYPu25
         PzTQyHKXEv5fen9kE6jF8GJyygaRH6U5dDgQCiR5TNnOTsHAEg0M++4WvtiPNMXLgazc
         rJ+NXTzfKm86ZpGCtwyOWH6VSEzHnN+vHoZKOhKjo3UtsQe/gTeTno674ZRNjK2VfHpl
         UtcA==
X-Gm-Message-State: APjAAAUS7rz0d8gGfjLY0XlWGs+2RpFdBxvd+o8t4R/EuCIMWjsgjm2J
        AuC+EpalirGgm+LfWNzaH227ypa2x6NT+I96HDm8wA==
X-Google-Smtp-Source: APXvYqwF/lDey/44H3kjnI1EW/XcWxjPOi+4mT3kp6ztUTkr7W6KuiYV+NefQFDaFmFbmfRUPcsC+RIWfCeo8thfE8E=
X-Received: by 2002:a6b:b549:: with SMTP id e70mr6033144iof.95.1565236091528;
 Wed, 07 Aug 2019 20:48:11 -0700 (PDT)
MIME-Version: 1.0
References: <20190807024917.27682-1-firo.yang@suse.com> <85aaefdf-d454-1823-5840-d9e2f71ffb19@oracle.com>
 <20190807083831.GA6811@linux-6qg8> <901704f1-163d-9dd8-4d20-93fa19f4435d@oracle.com>
In-Reply-To: <901704f1-163d-9dd8-4d20-93fa19f4435d@oracle.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Wed, 7 Aug 2019 20:48:00 -0700
Message-ID: <CAKgT0Uda0x8N7jv5Ex4x0tv85RgeHr5XQJCvDWCrD9VBu-4QPA@mail.gmail.com>
Subject: Re: [PATCH v2 1/1] ixgbe: sync the first fragment unconditionally
To:     Jacob Wen <jian.w.wen@oracle.com>
Cc:     Firo Yang <firo.yang@suse.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "jeffrey.t.kirsher@intel.com" <jeffrey.t.kirsher@intel.com>,
        "alexander.h.duyck@linux.intel.com" 
        <alexander.h.duyck@linux.intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 7, 2019 at 6:58 PM Jacob Wen <jian.w.wen@oracle.com> wrote:
>
>
> On 8/7/19 4:38 PM, Firo Yang wrote:
> > The 08/07/2019 15:56, Jacob Wen wrote:
> >> I think the description is not correct. Consider using something like below.
> > Thank you for comments.
> >
> >> In Xen environment, due to memory fragmentation ixgbe may allocate a 'DMA'
> >> buffer with pages that are not physically contiguous.
> > Actually, I didn't look into the reason why ixgbe got a DMA buffer which
> > was mapped to Xen-swiotlb area.
> Yes. I was wrong. You don't need to tell the exact reason.
> >
> > But I don't think this issue relates to phsical memory contiguity because, in
> > our case, one ixgbe_rx_buffer only associates at most one page.
>
> This is interesting.
>
> I guess the performance of the NIC in your environment is not good due
> to the extra cost of bounce buffer.

If I recall correctly the Rx performance for ixgbe shouldn't be too
bad even with a bounce buffer. The cost for map/unmap are expensive
for a bounce buffer setup but the syncs are just copies so they are
pretty cheap in comparison. The driver can take advantage of that on
Rx since it leaves the pages mapped and just syncs the portion of the
pages that are used.

Now if you are hitting the bounce buffer on the Tx side that is
another matter as you have to allocate the buffer on demand and that
is quite expensive.
