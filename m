Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F27329AD32
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 14:24:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1752098AbgJ0NYG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 09:24:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:33586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752084AbgJ0NYE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Oct 2020 09:24:04 -0400
Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9DB4420878;
        Tue, 27 Oct 2020 13:24:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603805043;
        bh=PECefxcOMLV7c0hbn8cf+aIW/r03dKBQ9nlsRb5VdDs=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=HwuK+hsJVCPMgJJnDVgBSy8reRpMrmqfsm9gO5+fbKq6F2XSpBQSROVY3juBqE4Nu
         H5Yst+NRh57BsdJz98NHJCoNBp87/Qn0YRuoRJC+edQJNMpnwjSYZD1XNb61xd/4R8
         NoOIHVXudUnL6JZ2eLTaTsIIIK+wa/E51N7WHr24=
Received: by mail-qv1-f48.google.com with SMTP id s17so598765qvr.11;
        Tue, 27 Oct 2020 06:24:03 -0700 (PDT)
X-Gm-Message-State: AOAM530Xwk6peIpP4HoI7x/ahCRJAOZPJ3Ow9zFDP1jqs0hxPVlCMI+d
        EGlQFMban8fXlYET2laLcEagwTqPE50QrcIjjcE=
X-Google-Smtp-Source: ABdhPJyYsHgGrutKNJ9QeFsKYMZe4jJ+Ai8O3vheG62leodhX3TrVBQ2KB+n8D6pJ5GsMDJ26+scj747BsrgAVcUS90=
X-Received: by 2002:a0c:c187:: with SMTP id n7mr2303412qvh.19.1603805042676;
 Tue, 27 Oct 2020 06:24:02 -0700 (PDT)
MIME-Version: 1.0
References: <20201026213040.3889546-1-arnd@kernel.org> <20201027035558.16864-1-xie.he.0141@gmail.com>
 <CAJht_EPSs6W-r6kpWUNQDPzCjL-+_8mqq2JBoY=qhsQREgn92g@mail.gmail.com>
In-Reply-To: <CAJht_EPSs6W-r6kpWUNQDPzCjL-+_8mqq2JBoY=qhsQREgn92g@mail.gmail.com>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Tue, 27 Oct 2020 14:23:46 +0100
X-Gmail-Original-Message-ID: <CAK8P3a3JTg5Mi2XC9AEC+YwH552M_TXDY4BaULZz5WmEb3woRQ@mail.gmail.com>
Message-ID: <CAK8P3a3JTg5Mi2XC9AEC+YwH552M_TXDY4BaULZz5WmEb3woRQ@mail.gmail.com>
Subject: Re: [PATCH net-next 01/11] atm: horizon: shut up clang null pointer
 arithmetic warning
To:     Xie He <xie.he.0141@gmail.com>
Cc:     Chas Williams <3chas3@gmail.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-atm-general@lists.sourceforge.net,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 27, 2020 at 5:02 AM Xie He <xie.he.0141@gmail.com> wrote:
>
> On Mon, Oct 26, 2020 at 8:56 PM Xie He <xie.he.0141@gmail.com> wrote:
> >
> > > -  for (mem = (HDW *) memmap; mem < (HDW *) (memmap + 1); ++mem)
> > > +  for (mem = (HDW *) memmap; mem < (HDW *) ((uintptr_t)memmap + 1); ++mem)
> >
> > Note that these two lines are semantically different. In the first line,
> > "+ 1" moves the pointer by (sizeof memmap) bytes. However in the second
> > line, "+ 1" moves the pointer by only 1 byte.
>
> Correction: in the first line "+ 1" moves the pointer by (sizeof *memmap) bytes.

Ah, of course. I had looked up the types but mixed up the memmap
and HDW definitions, but then got confused trying to understand the
logic in wr_mem() that operates on bytes but expands them into
multiples of 4.

I've modified it as below now, will resend along with the other patches
if you think this makes sense.

        Arnd

--- a/drivers/atm/horizon.c
+++ b/drivers/atm/horizon.c
@@ -1815,7 +1815,7 @@ static int hrz_init(hrz_dev *dev)

   int buff_count;

-  HDW * mem;
+  uintptr_t offset;

   cell_buf * tx_desc;
   cell_buf * rx_desc;
@@ -1841,8 +1841,8 @@ static int hrz_init(hrz_dev *dev)

   printk (" clearing memory");

-  for (mem = (HDW *) memmap; mem < (HDW *) (memmap + 1); ++mem)
-    wr_mem (dev, mem, 0);
+  for (offset = 0; offset < sizeof(struct MEMMAP); offset++)
+    wr_mem (dev, (HDW *)offset, 0);

   printk (" tx channels");
