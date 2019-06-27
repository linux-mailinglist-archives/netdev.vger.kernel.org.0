Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 691AE589A2
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 20:16:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726774AbfF0SQM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 14:16:12 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:37306 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726725AbfF0SQJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 14:16:09 -0400
Received: by mail-pg1-f196.google.com with SMTP id 25so1385322pgy.4;
        Thu, 27 Jun 2019 11:16:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=m0+YPM7FBeSRh30roCZZQ031FCJAEDwAQiegzwsg/hs=;
        b=u0FS++eMEQGTxOEAbkkW+8cTPU2ZRlQlFS1oIy/Mv7eZR+CtRz5c5VB2ggR2p7T+ZW
         ui5Bbi5z/mG2OobooPr0rNQLLD3xdcxVUYc1ZKqI+UxuQsxd5+OHIh4aQUArj1su7Q9D
         S+FoF9PEUtlWMJpU0941YlAgYKv23/34s3S2iAA183lgIlG0C2DBnkrMefCvAM6Krg83
         oXv9fVDjkR/0v/J/JrSrRtajTk5EDi1p3uZxf7KC9pvZ+HF6LqAHonqDoS8oFUoUD3h6
         XhdiMDyNM78LuxjnidtRCpb7Dt32IMPTRxUC8G5+qiGRrtKAVRlxxfGcwBdheR0u9Ebi
         QWjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=m0+YPM7FBeSRh30roCZZQ031FCJAEDwAQiegzwsg/hs=;
        b=aLVlnPit0ak2bKDigg4YvPJlOEvT/KMORoVKrz9wyFhaC2+wSpP5P0t6eIEA9/FDgj
         DhmR9EGqj6DznOsU++IIk0F05lmxsrWGYCslIbKMmnsDxYF1YuAJMfa2Qj7Uuo0yPVeN
         90r5jpxKDphMA/cslrE4TQh8yAFfk/TeGbeRXrL8Kg9bZCkZBku138tUk+8qstBeCoga
         vtDlT9RiMjgiHyd9ZfS2rt2cNINMMT2G5ZYgyKzeaQjMPeWMfSnkqY+5bCOtjW2IG9WQ
         57Q2JfauLuxt442etz/5HMOuVho6hNRHWSdT7jc8azXtHzsbVTXU4jnfLVF48VKYCxkS
         r3Tg==
X-Gm-Message-State: APjAAAXQPHzrzIZF335xofSsZlHDDK/BojChcg4oIoPoOJCjdx6QwPqL
        YkobGP/VdbqcSJ77L1wpJbo=
X-Google-Smtp-Source: APXvYqxZCO7by726PuDBPEISZRETZ9OTg7Jv9YeHQE1iPjgUNtMfXbF4iMxI7kTctaxBOSThWvvZCA==
X-Received: by 2002:a63:4c15:: with SMTP id z21mr4816529pga.87.1561659368830;
        Thu, 27 Jun 2019 11:16:08 -0700 (PDT)
Received: from localhost ([67.136.128.119])
        by smtp.gmail.com with ESMTPSA id s24sm3634958pfh.133.2019.06.27.11.16.08
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 27 Jun 2019 11:16:08 -0700 (PDT)
Date:   Thu, 27 Jun 2019 11:16:07 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     John Fastabend <john.fastabend@gmail.com>, daniel@iogearbox.net,
        jakub.kicinski@netronome.com, ast@kernel.org
Cc:     netdev@vger.kernel.org, edumazet@google.com,
        john.fastabend@gmail.com, bpf@vger.kernel.org
Message-ID: <5d1507e7b3eb6_e392b1ee39f65b463@john-XPS-13-9370.notmuch>
In-Reply-To: <156165697019.32598.7171757081688035707.stgit@john-XPS-13-9370>
References: <156165697019.32598.7171757081688035707.stgit@john-XPS-13-9370>
Subject: RE: [PATCH 0/2] tls, add unhash callback
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

John Fastabend wrote:
> Resolve a series of splats discovered by syzbot and noted by
> Eric Dumazet. The primary problem here is we resolved an issue on
> the BPF sockmap side by adding an unhash callback. This is
> required to ensure sockmap sockets do not transition out of
> ESTABLISHED state into a LISTEN state. When we did this it
> created a case where the interaction between callbacks in TLS
> and sockmap when used together could break. This resulted in
> leaking TLS memory and potential to build loops of callbacks
> where sockmap called into TLS and TLS called back into BPF.
> 
> Additionally, TLS was releasing the sock lock and then
> reaquiring it during the tear down process which could hang
> if another sock operation happened while the lock was not
> held.
> 
> To fix this first refactor TLS code so lock is held for the
> entire teardown operation. Then add an unhash callback to ensure
> TLS can not transition from ESTABLISHED to LISTEN state. This
> transition is a similar bug to the one found and fixed previously
> in sockmap. And cleans up the callbacks to fix the syzbot
> errors.
> 
> ---
>

Jakub,

If you could test this for the offload case that would
be helpful. I don't have any hardware here. We will still need
a few fixes in the unhash/hardware case but would be good to
know we don't cause any regressions here.

Thanks,
John
