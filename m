Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 576B4313552
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 15:39:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232380AbhBHOhI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 09:37:08 -0500
Received: from mail.xenproject.org ([104.130.215.37]:51080 "EHLO
        mail.xenproject.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232255AbhBHOgQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 09:36:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=xen.org;
        s=20200302mail; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
        MIME-Version:Date:Message-ID:References:Cc:To:From:Subject;
        bh=aivOqaGOcSxpvU6conwQTcZ0h2NZKR4vLEU5lBoBLnM=; b=TpQqFHUGQ309Z3JMnbU0rIfpjj
        ASrKoC0dMPhuUjLk3ViAyPeqvknYbyMrlu/ppcR+upMwaNIxtxB5uhfH28LHUOellFyF5th0KdgHs
        jKTAv2UPTPD50GHhHJfMLTxTwKrTdbDlgJtHRIu8230PgEIb7ppiHtcCI8fRvPRQBvDo=;
Received: from xenbits.xenproject.org ([104.239.192.120])
        by mail.xenproject.org with esmtp (Exim 4.92)
        (envelope-from <julien@xen.org>)
        id 1l97dF-0005YS-Lb; Mon, 08 Feb 2021 14:35:17 +0000
Received: from [54.239.6.177] (helo=a483e7b01a66.ant.amazon.com)
        by xenbits.xenproject.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <julien@xen.org>)
        id 1l97dF-0007Co-Df; Mon, 08 Feb 2021 14:35:17 +0000
Subject: Re: [PATCH 0/7] xen/events: bug fixes and some diagnostic aids
From:   Julien Grall <julien@xen.org>
To:     =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>,
        xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        linux-block@vger.kernel.org, netdev@vger.kernel.org,
        linux-scsi@vger.kernel.org
Cc:     Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        stable@vger.kernel.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        =?UTF-8?Q?Roger_Pau_Monn=c3=a9?= <roger.pau@citrix.com>,
        Jens Axboe <axboe@kernel.dk>, Wei Liu <wei.liu@kernel.org>,
        Paul Durrant <paul@xen.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
References: <20210206104932.29064-1-jgross@suse.com>
 <bd63694e-ac0c-7954-ec00-edad05f8da1c@xen.org>
 <eeb62129-d9fc-2155-0e0f-aff1fbb33fbc@suse.com>
 <fcf3181b-3efc-55f5-687c-324937b543e6@xen.org>
 <7aaeeb3d-1e1b-6166-84e9-481153811b62@suse.com>
 <6f547bb5-777a-6fc2-eba2-cccb4adfca87@xen.org>
 <0d623c98-a714-1639-cc53-f58ba3f08212@suse.com>
 <28399fd1-9fe8-f31a-6ee8-e78de567155b@xen.org>
 <1831964f-185e-31bb-2446-778f2c18d71b@suse.com>
 <e8c46e36-cf9e-fb30-21b5-fa662834a01a@xen.org>
 <199b76fd-630b-a0c6-926b-3e662103ec42@suse.com>
 <063eff75-56a5-1af7-f684-a2ed4b13c9a7@xen.org>
 <4279cab9-9b36-e83d-bd7a-ff7cd2832054@suse.com>
 <279b741b-09dc-c6af-bf9d-df57922fa465@xen.org>
Message-ID: <9f07dae5-050c-da2c-edc1-e1587dbae9c4@xen.org>
Date:   Mon, 8 Feb 2021 14:35:14 +0000
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <279b741b-09dc-c6af-bf9d-df57922fa465@xen.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 08/02/2021 14:20, Julien Grall wrote:
>>>> I believe this will be the case before our "lateeoi" handling is
>>>> becoming active (more precise: when our IRQ handler is returning to
>>>> handle_fasteoi_irq()), resulting in the possibility of the same race we
>>>> are experiencing now.
>>>
>>> I am a bit confused what you mean by "lateeoi" handling is becoming 
>>> active. Can you clarify?
>>
>> See above: the next call of the handler should be allowed only after
>> xen_irq_lateeoi() for the IRQ has been called.
>>
>> If the handler is being called earlier we have the race resulting
>> in the WARN() splats.
> 
> I feel it is dislike to understand race with just words. Can you provide

Sorry I meant difficult rather than dislike.

Cheers,

-- 
Julien Grall
