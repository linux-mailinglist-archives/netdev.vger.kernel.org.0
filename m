Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76E9D144C75
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 08:29:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725975AbgAVH3X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 02:29:23 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:34055 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725883AbgAVH3W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 02:29:22 -0500
Received: by mail-pf1-f195.google.com with SMTP id i6so2930317pfc.1
        for <netdev@vger.kernel.org>; Tue, 21 Jan 2020 23:29:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=0gedDWf1Om//3gqxfs2O2GAq4QYbbfW6nbpp9/SJLrA=;
        b=K0scC4UlmonkWq5aP/S3ZjJ8/URyXoFv1H7Z1UXLMQ6KFzMKz8RLqRT25M2osKfBPa
         51H7/wTOZpb3cQ9d6q+tsBLsACTdHdr4TIGAaeuCIvV4NNFZAjrNemuxiZV4ZIcjpyal
         RPyl6yDEmshfliYPtK2OR3Ps4rgVmHEWLVpU/bcSi2VG2bpA1f4vD1PQcguanBLKyJSj
         npC/Si1bGvD3bz2Awt5TVxMr8zGLT1st9/b+S7OfH0JOAOB52VaE81X4YI/FylHa6uKV
         a60JFatYuPN2kQ2ixwW69efsdSgAYKPQ13RRp/RjX8ViA8M1NzLU7jOd5uvmNbxofqoT
         9Sbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0gedDWf1Om//3gqxfs2O2GAq4QYbbfW6nbpp9/SJLrA=;
        b=CM4qwOPFTE+e8oAR4JkUg6t5hL3vrCF4HgUG7VMVdEt6PrA+K5OZntc3ThxnXrXotq
         6DMywxzwqHb+KyJcfytRV74l8HeqyRJo19Ghh/u4XhZIl5el+ID2YtsX+SWSdUOQVZJa
         MiUZxDq9xyE2+j0kyACHH2mSeC8Qe15yN7tleVUsPhayRMuTLJUw1Nn1H1QTnw48SUXA
         uNkjJm8cIWp2ax9qUmKfWF7Q2dqFnjBSEmaL7FbFm0Q9WDVFQHmJge6Gpj75olpe934N
         0b/MMmuReM4qJ5JIqILreACRpxEfXyaPKJLCnPIhoWbbqsZ71pJzg+59DqrkpCP4cedV
         cL5A==
X-Gm-Message-State: APjAAAU28ByNP5NS7Hkk6Ow5I/+u9r/T3RMexAMuJ38+WFFBr9fa67IS
        7kaYdlcpszyNw5fxqxXUR8GXWW0D
X-Google-Smtp-Source: APXvYqxxWqAEG4JLuDwMkzI/UrFbQ7T3smxRrdJ6yETNZ+Do4dEd0MtPAKocsXQNChwtBioY13uJ2w==
X-Received: by 2002:a63:26c4:: with SMTP id m187mr9879343pgm.410.1579678162257;
        Tue, 21 Jan 2020 23:29:22 -0800 (PST)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id l10sm1865208pjy.5.2020.01.21.23.29.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Jan 2020 23:29:21 -0800 (PST)
Subject: Re: [PATCH net-next v3 04/19] mptcp: Handle MP_CAPABLE options for
 outgoing connections
To:     Christoph Paasch <cpaasch@apple.com>, netdev@vger.kernel.org
Cc:     mptcp@lists.01.org, Peter Krystad <peter.krystad@linux.intel.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Westphal <fw@strlen.de>
References: <20200122005633.21229-1-cpaasch@apple.com>
 <20200122005633.21229-5-cpaasch@apple.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <b9cbc75f-8a0d-9273-54dc-81764cfb473c@gmail.com>
Date:   Tue, 21 Jan 2020 23:29:20 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200122005633.21229-5-cpaasch@apple.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/21/20 4:56 PM, Christoph Paasch wrote:
> From: Peter Krystad <peter.krystad@linux.intel.com>
> 
> Add hooks to tcp_output.c to add MP_CAPABLE to an outgoing SYN request,
> to capture the MP_CAPABLE in the received SYN-ACK, to add MP_CAPABLE to
> the final ACK of the three-way handshake.
> 
> Use the .sk_rx_dst_set() handler in the subflow proto to capture when the
> responding SYN-ACK is received and notify the MPTCP connection layer.
> 
> Co-developed-by: Paolo Abeni <pabeni@redhat.com>
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> Co-developed-by: Florian Westphal <fw@strlen.de>
> Signed-off-by: Florian Westphal <fw@strlen.de>
> Signed-off-by: Peter Krystad <peter.krystad@linux.intel.com>
> Signed-off-by: Christoph Paasch <cpaasch@apple.com>

Please make sure to CC me (edumazet@google.com) on TCP patches in general,
and on the whole MPTCP series while pushing them upstream.

netdev@ has delivered only 5 patches to my gmail.com account.

Thanks.



