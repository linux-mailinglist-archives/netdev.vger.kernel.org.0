Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D66466F90C
	for <lists+netdev@lfdr.de>; Mon, 22 Jul 2019 07:49:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727357AbfGVFs7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jul 2019 01:48:59 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:34170 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726534AbfGVFs7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jul 2019 01:48:59 -0400
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id 68A4C8EE105;
        Sun, 21 Jul 2019 22:48:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1563774538;
        bh=GBzZx34QSvoUf46NUopxvz+NmUwMBdn/Sm7BLWdcBQM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=DDMGmbIIE7cXvWSaDtPNEZfsdYQ5a9sfvOgssv1x1PJRgbyuuXrL1Gj5Yo56efQP4
         1a2V0nIiExrlNQbL3ZilUg57AumScNiclBDj+vR4chedEzKLEnsRKYgFfKLRMhpkMA
         3KZvivm6SzmoWmlwl8oUbf4n0Nt1Smymj/pDsIPU=
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 5x5v_jQuitfc; Sun, 21 Jul 2019 22:48:56 -0700 (PDT)
Received: from [192.168.222.203] (skyclub2.st.wakwak.ne.jp [61.115.125.222])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 1A52E8EE104;
        Sun, 21 Jul 2019 22:48:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1563774533;
        bh=GBzZx34QSvoUf46NUopxvz+NmUwMBdn/Sm7BLWdcBQM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=hmohQ8vQZcJdtFuOH9l0Hs/MQzRIFEzWkuIbLL2sdkQRzrcfrkczy2dR1hECCKunO
         MwXBMiE1bOQ/U9p33Lso5bF7g3YyrZPbhShQOmn6B8fK23Xto4X0yID+eMC4DVYnOe
         paeyWEzydvDxiCrUSVNpKNqtC4hF5wtG/AKaj9Fg=
Message-ID: <1563774526.3223.2.camel@HansenPartnership.com>
Subject: Re: [PATCH] unaligned: delete 1-byte accessors
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Alexey Dobriyan <adobriyan@gmail.com>
Cc:     akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, axboe@kernel.dk, kvalo@codeaurora.org,
        john.johansen@canonical.com, linux-arch@vger.kernel.org
Date:   Mon, 22 Jul 2019 14:48:46 +0900
In-Reply-To: <20190722052244.GA4235@avx2>
References: <20190721215253.GA18177@avx2>
         <1563750513.2898.4.camel@HansenPartnership.com>
         <20190722052244.GA4235@avx2>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2019-07-22 at 08:22 +0300, Alexey Dobriyan wrote:
> On Mon, Jul 22, 2019 at 08:08:33AM +0900, James Bottomley wrote:
> > On Mon, 2019-07-22 at 00:52 +0300, Alexey Dobriyan wrote:
> > > Each and every 1-byte access is aligned!
> > 
> > The design idea of this is for parsing descriptors.  We simply
> > chunk up the describing structure using get_unaligned for
> > everything.  The reason is because a lot of these structures come
> > with reserved areas which we may make use of later.  If we're using
> > get_unaligned for everything we can simply change a u8 to a u16 in
> > the structure absorbing the reserved padding.  With your change now
> > I'd have to chase down every byte access and replace it with
> > get_unaligned instead of simply changing the structure.
> > 
> > What's the significant advantage of this change that compensates
> > for the problems the above causes?
> 
> HW descriptors have fixed endianness, you're supposed to use
> get_unaligned_be32() and friends.

Not if this is an internal descriptor format, which is what this is
mostly used for.

> For that matter, drivers/scsi/ has exactly 2 get_unaligned() calls
> one of which can be changed to get_unaligned_be32().

You haven't answered the "what is the benefit of this change" question.
 I mean sure we can do it, but it won't make anything more efficient
and it does help with the descriptor format to treat every structure
field the same.

James

