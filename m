Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 741FE8DBFB
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 19:35:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728597AbfHNRfo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 13:35:44 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:45601 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727791AbfHNRfo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Aug 2019 13:35:44 -0400
Received: by mail-lf1-f67.google.com with SMTP id a30so16862010lfk.12
        for <netdev@vger.kernel.org>; Wed, 14 Aug 2019 10:35:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ipyg6fauzpsIdl/nnntiD6RmLQTr2+DndPSVDLw5Knc=;
        b=AC91ZFRZOoHN8Eu5C121EBTZkJKombXWjn8AEbPPblnSwvyWEZ1bLcACJ9iaURiarF
         aR2bk8B2YE+OzEX1spUSYTa0eckYU3jZ2YUbzqWVStoxSDCDvJs0iqDnRTfmNrBsrNXh
         QTQwCdrJ82O8/tYTtMNr4h8vs8ncP21lpJ2BiKpfSgFk9bfBwAK4XWZnQzrF7mqJqOEg
         c2Vhkjc86qMck9PUPfu3DmGzze/mtfDf+aL4fHYVKG39QccAPDHHTwZw899e8ALwpoH6
         bZ3986wO2QX3M+pVLJiOgT02Oy58s1NDK5BrbitMJqycPjjk+HkcRGCWGRftbv/e6Q+6
         5UDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ipyg6fauzpsIdl/nnntiD6RmLQTr2+DndPSVDLw5Knc=;
        b=ZRAjQ1WCtIsHvs9PR7KpiPNH5L2aLjIGUc3RdcAa39VgbJVmHiE+r5H7EmX0Qugbrr
         ts3KFtxPE7UAa8ARtn0e1Xr2lhR7AnT7M2qRYWE6GwadIx0pPtskBiURFHXXWQeKkmYs
         kFfCIWOpOUjDwg7Qxh95nIKy0oYy0rE/qBqyWCQNhVUL8Zxma8VGasAYgnfDzkLmNMGI
         XCZ/epVvPP0GGhPuV9NONDv3KoAzwWCnA1IetFdHKTb7ZiMz/+ERHxHNh0NqNlPfjfgS
         R23rmqBlmiTJqQNWbvMv1Acrze2E+Vx6zEp3cqWFPzJYYjtQbvgpsmFvXstbMRfJDopN
         Dbbg==
X-Gm-Message-State: APjAAAUKSUleUoxoTNljP9Xpb4eYgYGRrCMs7SrtQTHAlzBAHidubntj
        J29BJAJwxtk9XbDo1sTcAbuqocanWfHa1M7Pc/6icg==
X-Google-Smtp-Source: APXvYqzX1EqOTUK32r/nKOezalYcVOG74nUqE8Fd2oajf52nyXIKFH5hwq6/pu2siyEJoXjxDSjCMHktWLYOU09ELY4=
X-Received: by 2002:a19:641a:: with SMTP id y26mr281701lfb.29.1565804141930;
 Wed, 14 Aug 2019 10:35:41 -0700 (PDT)
MIME-Version: 1.0
References: <20190813162630.124544-1-sdf@google.com> <20190813162630.124544-3-sdf@google.com>
 <20190814172819.syz5skzil2ekdu5g@kafai-mbp>
In-Reply-To: <20190814172819.syz5skzil2ekdu5g@kafai-mbp>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Wed, 14 Aug 2019 10:35:30 -0700
Message-ID: <CAKH8qBvjBx21LXbGBDFqO6LVs5w8WO6X70hScyLETUGh4jGkfQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 2/4] bpf: support cloning sk storage on accept()
To:     Martin Lau <kafai@fb.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 14, 2019 at 10:28 AM Martin Lau <kafai@fb.com> wrote:
>
> On Tue, Aug 13, 2019 at 09:26:28AM -0700, Stanislav Fomichev wrote:
> > Add new helper bpf_sk_storage_clone which optionally clones sk storage
> > and call it from sk_clone_lock.
> Acked-by: Martin KaFai Lau <kafai@fb.com>
Thanks! Will send out a v4 to address Yonghong's and Daniel's suggestions.
