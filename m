Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93DB313D410
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 07:04:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729616AbgAPGD6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 01:03:58 -0500
Received: from host-88-217-225-28.customer.m-online.net ([88.217.225.28]:35211
        "EHLO mail.dev.tdt.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727026AbgAPGD6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jan 2020 01:03:58 -0500
Received: from mail.dev.tdt.de (localhost [IPv6:::1])
        by mail.dev.tdt.de (Postfix) with ESMTP id 06F4320FDF;
        Thu, 16 Jan 2020 06:03:54 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 16 Jan 2020 07:03:53 +0100
From:   Martin Schiller <ms@dev.tdt.de>
To:     David Miller <davem@davemloft.net>
Cc:     kubakici@wp.pl, khc@pm.waw.pl, linux-x25@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] wan/hdlc_x25: make lapb params configurable
Organization: TDT AG
In-Reply-To: <20200115.134339.199447041886048873.davem@davemloft.net>
References: <20200114140223.22446-1-ms@dev.tdt.de>
 <20200115.134339.199447041886048873.davem@davemloft.net>
Message-ID: <c31e38ac7cde9c753e3351209ee7687d@dev.tdt.de>
X-Sender: ms@dev.tdt.de
User-Agent: Roundcube Webmail/1.1.5
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED autolearn=ham
        autolearn_force=no version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.dev.tdt.de
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-01-15 22:43, David Miller wrote:
> From: Martin Schiller <ms@dev.tdt.de>
> Date: Tue, 14 Jan 2020 15:02:22 +0100
> 
>> This enables you to configure mode (DTE/DCE), Modulo, Window, T1, T2, 
>> N2 via
>> sethdlc (which needs to be patched as well).
>> 
>> Signed-off-by: Martin Schiller <ms@dev.tdt.de>
> 
> I don't know how wise it is to add new ioctls to this old driver.

As an user of this framework I can tell you that you need to be able to
tune this parameters if it's used in an professional environment.

> 
> Also, none of these ioctls even have COMPAT handling so they will
> never work from a 32-bit binary running on a 64-bit kernel for
> example.

How often does this constellation occur in reality? I really have no
idea. Our software is either 32-bit or 64-bit, not a mix.

> 
> Also:
> 
>> +static struct x25_state* state(hdlc_device *hdlc)
> 
> It is always "type *func" never "type* func"

Ok. I will change that. I've copied that from hdlc_fr.c to keep the
same coding style. But you are right:
"Don't look back, always look forward." :)
> 
>>  static int x25_open(struct net_device *dev)
>>  {
>>  	int result;
>> +	hdlc_device *hdlc = dev_to_hdlc(dev);
>> +	struct lapb_parms_struct params;
>>  	static const struct lapb_register_struct cb = {
> 
> Please make this reverse christmas tree ordered.

OK, will do.

> 
>> @@ -186,6 +217,9 @@ static struct hdlc_proto proto = {
>> 
>>  static int x25_ioctl(struct net_device *dev, struct ifreq *ifr)
>>  {
>> +	x25_hdlc_proto __user *x25_s = ifr->ifr_settings.ifs_ifsu.x25;
>> +	const size_t size = sizeof(x25_hdlc_proto);
>> +	x25_hdlc_proto new_settings;
>>  	hdlc_device *hdlc = dev_to_hdlc(dev);
>>  	int result;
> 
> Likewise.

ditto.

