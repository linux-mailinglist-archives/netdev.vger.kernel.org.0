Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C20E19590
	for <lists+netdev@lfdr.de>; Fri, 10 May 2019 01:03:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726777AbfEIXDK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 May 2019 19:03:10 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:36634 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726694AbfEIXDK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 May 2019 19:03:10 -0400
Received: by mail-lf1-f67.google.com with SMTP id y10so2759123lfl.3;
        Thu, 09 May 2019 16:03:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=oZBUuqK9FRm4rLL3g+cukKCfumYsWb0RftYMVko9Qy4=;
        b=Web1gVxRCsD99aM5spA9w8OVrodnK/QXMUu+GO7hTFGFtVXnimHYazzXF7ejEKNVHp
         VLZ4m5jX543qtcgz8iohg35mu3IQoP3h74EtMFPA4bwrKe/n8p+JiFoMDB/t+GKlMTOp
         0g23sx3nGPYdjQbSWz/QA1KRcq/g1VxlnoLNQG5Won85Zg7TCOw9G29knklf/pdP4Td1
         6XvMHQkgGJ6n56RAC2seCr15fPDbWDSEEA0H1c7KqOgY+GjzoZU+ZgInbU1YdO+oBe2X
         BfJCFjWvKLAP6b8mSus1DeENn571cWcRotmJhLMuMdIBq9yg+kHsUAs07PA+JBQEGMlO
         yQxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=oZBUuqK9FRm4rLL3g+cukKCfumYsWb0RftYMVko9Qy4=;
        b=L002Q9LOfIALRXbWS5Nta2AcgoyfHPq7HU5D7gz5H5TIuDFodCe8hyHp13VFIYT3pp
         r8vtxtkriL9ZnC2twLYalHiYlopndZRa8N8dWwsmNlIcGFkfAPvpcPVfBjSIP4IIiqo0
         OrC6zTr5s9J0Yc43udxNlFYzxFTtSvI4lEZz1nrVcV//DGC7752/ULFAfxbV3PvmKKOs
         CTD9EFI7r7+dOh7aaGy0l+Avs4XPm46tDy7bxwIdoqECGPR3MlS7X2cd05BSIUrPcL/b
         /8+8RHJVeXIR7aqyeQ4gkP05iLcsSz4/IS8HcgVrkW4ZpGGPCf5JXZc5Om4VnAkUQocQ
         orbA==
X-Gm-Message-State: APjAAAVRoU1gNYn8/MgMZb17YYL/u6BDoyp4bUDhKdHP6dUhdSPATwhF
        9RDv6EcnV1Q7f2ndMrt0IcjqjG/8RWasFZ6UnBr5NA==
X-Google-Smtp-Source: APXvYqzgdAtLiC1dCf+WIZBVON8ZaYCZCVFIFCASFHnPomN980oo8PrGWI115MmtJhcXgVimq/cUyQPyrVxK/XDYMMI=
X-Received: by 2002:a19:81d4:: with SMTP id c203mr3923767lfd.160.1557442988272;
 Thu, 09 May 2019 16:03:08 -0700 (PDT)
MIME-Version: 1.0
References: <1557247291-9686-1-git-send-email-jiong.wang@netronome.com>
In-Reply-To: <1557247291-9686-1-git-send-email-jiong.wang@netronome.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 9 May 2019 16:02:56 -0700
Message-ID: <CAADnVQLjsy4snC85RK53_qQcmikTj+SySZ1ziY-Bw5OTCOadFQ@mail.gmail.com>
Subject: Re: [PATCH bpf] nfp: bpf: fix static check error through tightening
 shift amount adjustment
To:     Jiong Wang <jiong.wang@netronome.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Oleksandr Natalenko <oleksandr@natalenko.name>,
        bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        oss-drivers@netronome.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 7, 2019 at 9:42 AM Jiong Wang <jiong.wang@netronome.com> wrote:
>
> NFP shift instruction has something special. If shift direction is left
> then shift amount of 1 to 31 is specified as 32 minus the amount to shift=
.
>
> But no need to do this for indirect shift which has shift amount be 0. Ev=
en
> after we do this subtraction, shift amount 0 will be turned into 32 which
> will eventually be encoded the same as 0 because only low 5 bits are
> encoded, but shift amount be 32 will fail the FIELD_PREP check done later
> on shift mask (0x1f), due to 32 is out of mask range. Such error has been
> observed when compiling nfp/bpf/jit.c using gcc 8.3 + O3.
>
> This issue has started when indirect shift support added after which the
> incoming shift amount to __emit_shf could be 0, therefore it is at that
> time shift amount adjustment inside __emit_shf should have been tightened=
.
>
> Fixes: 991f5b3651f6 ("nfp: bpf: support logic indirect shifts (BPF_[L|R]S=
H | BPF_X)")
> Reported-by: Oleksandr Natalenko <oleksandr@natalenko.name>
> Reported-by: Pablo Casc=C3=B3n <pablo.cascon@netronome.com
> Reviewed-by: Quentin Monnet <quentin.monnet@netronome.com>
> Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
> Signed-off-by: Jiong Wang <jiong.wang@netronome.com>

Applied. Thanks
