Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6996C102FA8
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 00:01:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727354AbfKSXBj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 18:01:39 -0500
Received: from mail-lf1-f43.google.com ([209.85.167.43]:44085 "EHLO
        mail-lf1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726025AbfKSXBj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 18:01:39 -0500
Received: by mail-lf1-f43.google.com with SMTP id n186so6083727lfd.11;
        Tue, 19 Nov 2019 15:01:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yW8LBEzAnheT1IwIq3nIKF7G0cRF++nm/AYiGQqnSk8=;
        b=V+o89SHgX7wKqKFU4eRMRmF1FBTDZp9FN+MlGVo3Wnj575PDqDdi4e+nfAxjTIA+FW
         NBhnlsm36UPcw6Lb/uJ2XW1Z5kZbQ0L61M84Vab69BVNtTSrqqk9FsXXwGhyjzXSOX2e
         I8/lgRG9HCghhx2LfrRxUtPjJ9Q581RnRRaaMHrW3l2ZB+jf0/Z/jz57aCI4a3hqITAT
         EXJPhTu4LRGpRA8T4dbGlMeR3nDvVss9d71cBHKTNgrxeVknKrHBapNYC6qthazLGkl8
         xG1LoDh6GCyJou8twLBvLiPGNVOVQ1D8wTvFCyBU/R02FEZkcF6PpD2Mv7tStZGRiYn5
         x5qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yW8LBEzAnheT1IwIq3nIKF7G0cRF++nm/AYiGQqnSk8=;
        b=kWfVKUmM1B1+zNaf+LPqcqh8XCF5M3dh6g83/Wtnt+EWNsC4a5dk9gAjX0Ra3cQEEe
         6ZhbqnZBCVqfVbowWPIZsImfy3rGp8v7nrtyguisI1goLr0NlzsehEGAsoWD0sJBtJXN
         P7staRTXtZ5zO0PhkLEYA3Q5SM3gp2DfBrHDKtVMaGU+JdlraY31eDf6NydVH6n7Hb+l
         s7kNXe0KNy4GJ2seIQespkT9rmwBtsyUqCUlXPghAqtnW3iWGPkvY82NTgz4sMeXrCl7
         8IDIE41r9qFPZ7FDP8EL6+AiFQ9b0LuvepDE0mUXRTPDtOyw++DFqah/v1lNJN+8zu6D
         D8+w==
X-Gm-Message-State: APjAAAX5vz/8sZCa+PieTpqLOBxW6yj+yc6ZS+IqdwgQUdUAafBgJ+WK
        PxINdAnkjjL3w0tMf94X3ZTOCom2H8tRWGBvIU0=
X-Google-Smtp-Source: APXvYqzduu8V654TXWiYmsv+6bRFwWlvLgoyyJ8r1peoOouVgNh74iTIXMUBSNOY6LSQrfylymJVNumfyLCjpii+vj0=
X-Received: by 2002:a19:3845:: with SMTP id d5mr109012lfj.162.1574204497327;
 Tue, 19 Nov 2019 15:01:37 -0800 (PST)
MIME-Version: 1.0
References: <20191119224447.3781271-1-andriin@fb.com>
In-Reply-To: <20191119224447.3781271-1-andriin@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 19 Nov 2019 15:01:25 -0800
Message-ID: <CAADnVQKQZB04iuHeOMB_yTEnwZs1NYN=Vn-XyJ6PrA1ZZG7q5A@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next] libbpf: fix call relocation offset
 calculation bug
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 19, 2019 at 2:45 PM Andrii Nakryiko <andriin@fb.com> wrote:
>
> Convert few selftests relying on bpf-to-bpf calls to use global functions
> instead of static ones.
>
> Reported-by: Alexei Starovoitov <ast@kernel.org>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

This one works. Applied.
I manually added Fixes tag and Yonghong's Ack.
