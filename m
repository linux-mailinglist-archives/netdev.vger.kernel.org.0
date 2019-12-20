Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88104127F41
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 16:28:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727535AbfLTP16 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Dec 2019 10:27:58 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:42841 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727395AbfLTP15 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Dec 2019 10:27:57 -0500
Received: by mail-wr1-f65.google.com with SMTP id q6so9770246wro.9
        for <netdev@vger.kernel.org>; Fri, 20 Dec 2019 07:27:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=QgvFx5YHtxnECnkDBTqxzi0EKbhnWjIBCvLL8T47+vI=;
        b=kQ6Lv3XkbX3KIEyHrz312HKNFMhGmuM0GPmyZ85L4Qb1qsZ3vS48omlzbhvg1m7rv0
         ZMsas043coV+I5M8/bN2SpnBSnf30zYcnCF98ZN9/Phu3ani77nk1wb+rHOjjBmL16s4
         JWSBAYbAROCTKypMACXva0kCw1qRgndS6AhPFuz8/YlByLO6XsnqUzuG2UqIhcamrR+/
         rgg6MoADwoO3fV6l6mMNDQr42wTExhgEW/zxjgs+FRvuMxcpM7A31snj5+JAHhXVdM7v
         gHhHNyUWNCfKWRoNxIXpLoPXBona/UgOQCrzZUdWq2FGnf9DzEyV7JOWg1BGmlpVubyU
         fxRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QgvFx5YHtxnECnkDBTqxzi0EKbhnWjIBCvLL8T47+vI=;
        b=ZLSV6SZ3Ykds9FbiZqeh8gaMBrxDvAPvwhcPeZww3ZxmKib5qZuSMxAAyN/3QUAI/O
         3jYAq59OwUnHvnZygCBDkPJNeyFMM1HiDVlHe0Y1tHUMo3Xyj5+DQOjBoF/lcb3AQja0
         CkLtjegQf9weAKPhw89mfT6S11Up8A4o2GS7hlM89hRh7drRybXUf8qy+5YWwlCAMgyx
         0rIA0BO17beMYxIkwkp4VxAeFjKclanVYh6Hyu0VmXIr9KcjN8qkBJmw3k7Xb5+lHb9/
         x7C5XtC8/pb3ibdKT070RysO4xwSB+P+VbmZz2PrpyX9fAfP7GQDtdr3ldDPPKpRLMVw
         VDhQ==
X-Gm-Message-State: APjAAAXJUzeAMjLlpQUDv0sJqNh/3ZobV+EGzIoLBHVnYkiG9DUNR+WP
        t8FZ7WwzHiTxizWi4jVZrEE=
X-Google-Smtp-Source: APXvYqz+q+5o566ccpNL+Wp1HQq1d6uok6rYp8sP0AyGG6XqKSm98H8uQZZg8XrNikrtj9HuCFMz9w==
X-Received: by 2002:a5d:4602:: with SMTP id t2mr15593815wrq.37.1576855676229;
        Fri, 20 Dec 2019 07:27:56 -0800 (PST)
Received: from [192.168.8.147] (72.173.185.81.rev.sfr.net. [81.185.173.72])
        by smtp.gmail.com with ESMTPSA id q3sm9735355wmj.38.2019.12.20.07.27.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Dec 2019 07:27:55 -0800 (PST)
Subject: Re: [PATCH net-next v5 09/11] tcp: Check for filled TCP option space
 before SACK
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        netdev@vger.kernel.org, mptcp@lists.01.org
Cc:     Paolo Abeni <pabeni@redhat.com>
References: <20191219223434.19722-1-mathew.j.martineau@linux.intel.com>
 <20191219223434.19722-10-mathew.j.martineau@linux.intel.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <034d02ef-e760-3cfa-a6a4-4a1943e73783@gmail.com>
Date:   Fri, 20 Dec 2019 07:27:54 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191219223434.19722-10-mathew.j.martineau@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/19/19 2:34 PM, Mat Martineau wrote:
> Update the SACK check to work with zero option space available, a case
> that's possible with MPTCP but not MD5+TS. Maintained only one
> conditional branch for insufficient SACK space.
> 
> v1 -> v2:
> - Moves the check inside the SACK branch by taking recent SACK fix:
> 
>     9424e2e7ad93 (tcp: md5: fix potential overestimation of TCP option space)
> 
>   in to account, but modifies it to work in MPTCP scenarios beyond the
>   MD5+TS corner case.
> 
> Co-developed-by: Paolo Abeni <pabeni@redhat.com>
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
> ---

Reviewed-by: Eric Dumazet <edumazet@google.com>

