Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5647A6D618
	for <lists+netdev@lfdr.de>; Thu, 18 Jul 2019 22:56:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403789AbfGRU4c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jul 2019 16:56:32 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:36209 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728028AbfGRU4c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jul 2019 16:56:32 -0400
Received: by mail-lj1-f194.google.com with SMTP id i21so28718804ljj.3;
        Thu, 18 Jul 2019 13:56:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vOzSyzgb+bkfe/D8S+qighRsRokrjBcHMARbXsAEeAA=;
        b=kEFFoaBtAhJhdUHUI7WDIrh1B4MxYcCvAsq6E1MrS0Nfcx2yjMtXUs4Uf/pVdtOccb
         16qZettrPzW51p4DtN7vrnPrQVTVI/XUF7m17QvlYRGCILtl/rBp3rXXmdmr/U8AYG1b
         iC77VTI/eBiNhDXSCOIENKhlso/cD7wNhYZ9JK6UxfcXpXj6MzXI1wy/0TcyG75XhxxA
         lut/bIQpfPuNw/DyG0trLLKdxvP/crFOWrXhfqX6J4KLihVBfGai1BFFb2euUIjnhyL9
         UYkaV8tQyFv7qm9/3PDtCokhxyYWDPrhMRZa1R70zSoDNKur0oAtGfhnVxUHsrxUsbHj
         R6rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vOzSyzgb+bkfe/D8S+qighRsRokrjBcHMARbXsAEeAA=;
        b=eeFSASOQi1NbBGPYQMZvy+NCzAYAKMrEnBXaErGLkMViqPgnOt+M86d39c1k4w7A1h
         E9XJEFyFTxeUB4cwI2wg23+Rkrk+X05WLZ9fNp63w2eMIb/uWOZ8ZQKy5GnIA7t5P6ik
         XFiPoiiPGL6KLrw4VrC2bH7AXbNllDZlYMQr5QjkmjxP2EiDMaGVEO8XpC0t7rHbItDJ
         fYsT02n1aSEf8CIfzrMCp2neIiDMO+Ng50WYC/D0JVUVXXtKIm21svNL2KGAjpMIx/w8
         skT/KNo2g1l/gCli0xY8hCHlfM+7hVr3Y1xDkKlEH6UNjlZMOWIyUHGGviLHfeTUEcuZ
         R5Ig==
X-Gm-Message-State: APjAAAXfirH0c6ePVwwTeScO0wt2O9+YaUupBhcqY0A7m2fMgwjgEDKe
        cNIpeg6bDJ/Uot15TYd9pFY14ayZSzbxb9Cze6U=
X-Google-Smtp-Source: APXvYqz7tQNCs5nyAkUTjBejJF9XAOLGg26Ek3akBdAAceqmLVFUL+wbZxQTmdASZVmtcK4kMK7jxDuSaNtg2MTtZSI=
X-Received: by 2002:a2e:968e:: with SMTP id q14mr23808202lji.195.1563483390036;
 Thu, 18 Jul 2019 13:56:30 -0700 (PDT)
MIME-Version: 1.0
References: <20190717122620.58792-1-iii@linux.ibm.com>
In-Reply-To: <20190717122620.58792-1-iii@linux.ibm.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 18 Jul 2019 13:56:18 -0700
Message-ID: <CAADnVQ+aha2anSmzbm4ZrV+eaHTKeuAYVu8wRw6E+PapYreiAQ@mail.gmail.com>
Subject: Re: [PATCH bpf] selftests/bpf: fix test_xdp_noinline on s390
To:     Ilya Leoshkevich <iii@linux.ibm.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        gor@linux.ibm.com, Heiko Carstens <heiko.carstens@de.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 17, 2019 at 5:29 AM Ilya Leoshkevich <iii@linux.ibm.com> wrote:
>
> test_xdp_noinline fails on s390 due to a handful of endianness issues.
> Use ntohs for parsing eth_proto.
> Replace bswaps with ntohs/htons.
>
> Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
> Acked-by: Vasily Gorbik <gor@linux.ibm.com>

Applied. Thanks
