Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 027C4170F01
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 04:27:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728273AbgB0D1b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 22:27:31 -0500
Received: from mail-qt1-f196.google.com ([209.85.160.196]:38435 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728238AbgB0D1b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 22:27:31 -0500
Received: by mail-qt1-f196.google.com with SMTP id e20so539576qto.5
        for <netdev@vger.kernel.org>; Wed, 26 Feb 2020 19:27:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=digitalocean.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=pmaPe19WB2ZFYGWPJMidDfkgFMRVVu0THKJ2EY7sg1Q=;
        b=Bx/BSYFqBsuGrUVgHdY6YunH+jg8ZTG/JvmTF90WZMPBnYsNWiwIxe9gOyVVgoI2Dd
         cvmd556QB7poYFa2sgZL+NJU0nwQJ1zyRYacbiVVJkrWk5iJWoF8hOu2Et8Y1C7srKgq
         oUaCu3xSTD2il7FBVGEerHbO3GxT5E0JLla7A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pmaPe19WB2ZFYGWPJMidDfkgFMRVVu0THKJ2EY7sg1Q=;
        b=aOgSijWeCaBg/8yZjUiwWblpWiHCfHSViA2UjTppcsQAmS/mzn8WU1EAsTxLUgCcA0
         ydbD7TOGWXbeHYNvBXq6yWgRSDHVJhiuT969vXLvLuNyzlZmmyutuozMdT83DuPF7PY5
         BXS5epCBsUG9T9YAuLm5xT3RInRXeA2zHO4ZE7sJIVjUE56iMsJuyLXhR7TWBnqOOyt5
         x47lcpXwka5O7kuCwxPn+B/BqWDWUM7b2zpQytcR5A/KXplYdiBA0sVnCTSNyzKeqBox
         WTvQcS+nHGg1HW35AWIFFPVUs3CB1Wy8AuLU7BJmQskyKllB5usZjcT3i2V7RZJOKgPg
         3yXw==
X-Gm-Message-State: APjAAAUzc1CRxta8PcYA19mhbt/D5dfJEQmSS5Erad3wM4FpSsoB18Lu
        dkI1uoZ2Tg5UKqFDfapHrTmQFw==
X-Google-Smtp-Source: APXvYqyWvTo/Drr+PQojvpjpEG1//54WYTYUu8ln+h8TIaUfgqJ3fU8uPvv4VfWSHi2Ies7bEKa3VA==
X-Received: by 2002:ac8:73c7:: with SMTP id v7mr2354336qtp.269.1582774050000;
        Wed, 26 Feb 2020 19:27:30 -0800 (PST)
Received: from ?IPv6:2601:282:803:7700:a58e:e5e0:4900:6bcd? ([2601:282:803:7700:a58e:e5e0:4900:6bcd])
        by smtp.gmail.com with ESMTPSA id q39sm29135qtb.43.2020.02.26.19.27.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Feb 2020 19:27:29 -0800 (PST)
Subject: Re: [PATCH RFC net-next] virtio_net: Relax queue requirement for
 using XDP
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Cc:     David Ahern <dsahern@gmail.com>, Jason Wang <jasowang@redhat.com>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org
References: <20200226005744.1623-1-dsahern@kernel.org>
 <23fe48b6-71d1-55a3-e0e8-ca4b3fac1f7f@redhat.com>
 <9a5391fb-1d80-43d1-5e88-902738cc2528@gmail.com> <87wo89zroe.fsf@toke.dk>
 <20200226032204-mutt-send-email-mst@kernel.org> <87r1yhzqz8.fsf@toke.dk>
From:   David Ahern <dahern@digitalocean.com>
Message-ID: <0dc879c5-12ce-0df2-24b0-97d105547150@digitalocean.com>
Date:   Wed, 26 Feb 2020 20:27:27 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <87r1yhzqz8.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/26/20 1:34 AM, Toke Høiland-Jørgensen wrote:
>> OK so basically there would be commands to configure which TX queue is
>> used by XDP. With enough resources default is to use dedicated queues.
>> With not enough resources default is to fail binding xdp program
>> unless queues are specified. Does this sound reasonable?
> Yeah, that was the idea. See this talk from LPC last year for more
> details: https://linuxplumbersconf.org/event/4/contributions/462/
> 

Can we use one of the breakout timeslots at netdevconf and discuss this
proposal and status?

