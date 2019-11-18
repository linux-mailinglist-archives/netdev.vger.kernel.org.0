Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1A03100136
	for <lists+netdev@lfdr.de>; Mon, 18 Nov 2019 10:25:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726686AbfKRJZK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 04:25:10 -0500
Received: from mail-lf1-f65.google.com ([209.85.167.65]:38551 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726460AbfKRJZJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Nov 2019 04:25:09 -0500
Received: by mail-lf1-f65.google.com with SMTP id q28so13194901lfa.5
        for <netdev@vger.kernel.org>; Mon, 18 Nov 2019 01:25:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=unikie-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-transfer-encoding;
        bh=KvUv7Ch0gpGiMYEl/kx/KYqF9gBTZP2R/wJjUKL/C+A=;
        b=FngUiVXYjQ53t27cyMOTTaplcI1E7UL/Q5j+t2mprd+k2440Sae5YblHvNGla6ISvc
         U65MmZ8pH9szeh1wxcddqilQVg8NVhwuZcCNsU/SWlgOmYuuhoQnAapzrnFBsg3pZuLK
         zCSGlFc3ZywBjqfYRWOkEn80RBC8ihBWgJlYWor6eNvEEtwbpmLqRX2bM65x11kOIXjt
         iHW+TaN3STWigIDWR1CGIAVvbUP1rQGaKl8/G1TeKRVD4r8jA6uzy3DVGdh5iDcgafu9
         81lKfO+6ESuAkUj7W+crj7pjonaIGoABTc0SzPE+RU9Vt0RDGoDCsUeXbdkyIkZ19kfZ
         qnNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:references:date:in-reply-to
         :message-id:user-agent:mime-version:content-transfer-encoding;
        bh=KvUv7Ch0gpGiMYEl/kx/KYqF9gBTZP2R/wJjUKL/C+A=;
        b=Rs57RijQFYnv5HSsJKkB7CclNOxoozsebFfvajkBDz7ey3dupT2Mue3L9eBsSfsn5R
         CS/0lvWmXDatbhl6JMLChCZbDG1VfPjmEcAYXUcbT1EcupfKm89zLZ1LAKGvIVPbkB7c
         R4NJroKaIrb2GplDYsrMm8EKV6muizEuBJCmLkFIP7DA64JL6vmnkCqMmAXQiu0gMpDO
         4mHdxKglfLedQCtHExNixcWoPIWfo8mWeEkRZbWa0REmGl9+gzqBX32OePi5jACTPPqd
         nZl6P5g8CbgyZTx0HGn/TRKxGdYGgeo92pDs+SY3LCnCKYc1z6YKvBk7BbeQ1OWXtsAV
         tzbQ==
X-Gm-Message-State: APjAAAX6y5rl7xPCrpTIifRB+aKokaBrdNHE0rKvNPXRKBCImxKCivkc
        s8njDTomEPOpPSVXHoSUFRAL6g==
X-Google-Smtp-Source: APXvYqwe4TwA8XPvggXjl5hDlyGbPYZ/xD2/90cBgwfG/GJy7+vtVBKhc2rUu9FA0XuQLPXKoQT9uQ==
X-Received: by 2002:a19:520b:: with SMTP id m11mr19519869lfb.77.1574069107645;
        Mon, 18 Nov 2019 01:25:07 -0800 (PST)
Received: from GL-434 ([109.204.235.119])
        by smtp.gmail.com with ESMTPSA id h2sm7183993lfd.58.2019.11.18.01.25.06
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 18 Nov 2019 01:25:07 -0800 (PST)
From:   jouni.hogander@unikie.com (Jouni =?utf-8?Q?H=C3=B6gander?=)
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>
Subject: Re: [PATCH] net-sysfs: Fix reference count leak
References: <20191115122412.2595-1-jouni.hogander@unikie.com>
        <20191115152416.GA377478@kroah.com>
Date:   Mon, 18 Nov 2019 11:25:05 +0200
In-Reply-To: <20191115152416.GA377478@kroah.com> (Greg Kroah-Hartman's message
        of "Fri, 15 Nov 2019 23:24:16 +0800")
Message-ID: <87tv718rke.fsf@unikie.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/25.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Greg Kroah-Hartman <gregkh@linuxfoundation.org> writes:

> On Fri, Nov 15, 2019 at 02:24:12PM +0200, jouni.hogander@unikie.com wrote:
>>  net/core/net-sysfs.c | 21 ++++++++++++++++-----
>>  1 file changed, 16 insertions(+), 5 deletions(-)
>>=20
>> diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
>> index 865ba6ca16eb..72ecad583953 100644
>> --- a/net/core/net-sysfs.c
>> +++ b/net/core/net-sysfs.c
>> @@ -1626,6 +1626,12 @@ static void netdev_release(struct device *d)
>>  {
>>  	struct net_device *dev =3D to_net_dev(d);
>>=20=20
>> +	/* Triggered by an error clean-up (put_device) during
>> +	 * initialization.
>> +	 */
>> +	if (dev->reg_state =3D=3D NETREG_UNINITIALIZED)
>> +		return;
>> +
>
> Are you sure about this?  What about the memory involved here, what will
> free that?

In net/core/dev.c:free_netdev:

        /*  Compatibility with error handling in drivers */
	if (dev->reg_state =3D=3D NETREG_UNINITIALIZED) {
		netdev_freemem(dev);
		return;
	}

I.e. driver is expected calling free_netdev in case of error and freeing
of device structure is done there. This brings up the question wether
put_device should be actually called in free_netdev also in error case?
Maybe that would be more correct as this free_netdev exists.

BR,

Jouni H=C3=B6gander
