Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C3B329823E
	for <lists+netdev@lfdr.de>; Sun, 25 Oct 2020 16:13:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1416947AbgJYPNa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Oct 2020 11:13:30 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:23370 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2408107AbgJYPN3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Oct 2020 11:13:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603638808;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BW0pmlSPihsKBpCrU+u9mnxvxiC531ZaObDfhIazzx0=;
        b=fFnKSH26F5xQxp4Act0DZxwcqJ3+TxTZ9VGBlz1HL0YJOuNKkmOjzrUqfHYEawH/i7cLq2
        6cNqRFZ51A/pc+4Uv4ogR2WmiJpKuqeAMARUfh5hCF619uBDUT3oFPLDpE2B6bAzAUjbRb
        7iqCKA6XZUrMTCCJgx06aSL0RQLMEtU=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-392-sgloDmfDPJKK16FxL_Lbvw-1; Sun, 25 Oct 2020 11:13:26 -0400
X-MC-Unique: sgloDmfDPJKK16FxL_Lbvw-1
Received: by mail-io1-f72.google.com with SMTP id e21so4305701iod.5
        for <netdev@vger.kernel.org>; Sun, 25 Oct 2020 08:13:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=BW0pmlSPihsKBpCrU+u9mnxvxiC531ZaObDfhIazzx0=;
        b=DRJ711hJw8vqA63vYAuE3ZCP0aiJxmFu1Rjyv2tT413eCaQ/lDozJxvpn+CvTKi2Fv
         1xVBhjggnnl5FvQCJtmHfr02ZlyH+QI3Bh9c2CKG6qKtulkBGbzHu1p/90cwzJ5pZF0q
         jlwm+BnkE4v3i1346jAJ5YhIdOE93l6Rp7OFSsDL8zIm8fG0lhTQND2sH5NPSSi8Qk9g
         wAgTyWp25cu2dcUWJL0oFkg0JVh84BeF99kxwDPqmjoJMdmtxQHM1Ueut/YNvGUrFJG1
         RgbRi+QIil1FiR7WKBm/4sRcqoX9oMq3NljeA+s7bZXQW7CqDoiOAS2WjhTUiPPGUbwV
         JtPw==
X-Gm-Message-State: AOAM531if5rUNPKlnV4Tp1ZC/U+/3MSpAApn8Diqusd8G/Bd7GV2dCBR
        Tfek+FIApzLO6Na4MFtHS4H2j9hEUCXDdKNYA+NmNYZ948OD4XrU6ye/gK9E7HRuGONWtfb3m4V
        z81Sn83/F7r32oJwZ
X-Received: by 2002:a02:a518:: with SMTP id e24mr8689340jam.131.1603638805890;
        Sun, 25 Oct 2020 08:13:25 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxlQldSJLlwusJU2GMA08/TIVvvRjeRtzaxuUFVvAU2jTRs4z6GmjyPCYejdk4BG+O81YDuqw==
X-Received: by 2002:a02:a518:: with SMTP id e24mr8689318jam.131.1603638805601;
        Sun, 25 Oct 2020 08:13:25 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id f22sm2347281ioh.34.2020.10.25.08.13.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Oct 2020 08:13:24 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 1A55C181CEC; Sun, 25 Oct 2020 16:13:23 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     David Ahern <dsahern@gmail.com>, Hangbin Liu <haliu@redhat.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>, David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Jiri Benc <jbenc@redhat.com>,
        Andrii Nakryiko <andrii@kernel.org>
Subject: Re: [PATCH iproute2-next 3/5] lib: add libbpf support
In-Reply-To: <29c13bd0-d2f6-b914-775c-2d90270f86d4@gmail.com>
References: <20201023033855.3894509-1-haliu@redhat.com>
 <20201023033855.3894509-4-haliu@redhat.com>
 <29c13bd0-d2f6-b914-775c-2d90270f86d4@gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Sun, 25 Oct 2020 16:13:23 +0100
Message-ID: <87eelm5ofg.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Ahern <dsahern@gmail.com> writes:

> On 10/22/20 9:38 PM, Hangbin Liu wrote:
>> Note: ip/ipvrf.c is not convert to use libbpf as it only encodes a few
>> instructions and load directly.
>
> for completeness, libbpf should be able to load a program from a buffer
> as well.

It can, but the particular use in ipvrf is just loading half a dozen
instructions defined inline in C - there's no object files, BTF or
anything. So why bother with going through libbpf in this case? The
actual attachment is using the existing code anyway...

-Toke

