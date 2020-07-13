Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EEBB21E0E6
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 21:40:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726582AbgGMTkJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 15:40:09 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:29766 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726339AbgGMTkJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 15:40:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1594669207; x=1626205207;
  h=references:from:to:cc:in-reply-to:date:message-id:
   mime-version:content-transfer-encoding:subject;
  bh=CjOb2b1kANhvs97jDVtBc8KNUp0VqHC5EskyQiDz8V4=;
  b=L//FYSOh3TIbdX+I7Ys91DP0givJ3gRVjCPWp5ejdDSPhk17cwdXlBLZ
   kXYqkwhaN8ASCvWQc72zP4LJcW8+XRa3ecAt7HiihsikxLsxjDbx/hMYP
   ozebS7Ua4Q3H96B2drC/+ALi3otjcxgpST7z04OK3m69QfwdxBvl8+TWw
   8=;
IronPort-SDR: Ni2EoGVZejCPj+/ClkxWIj/0zIpPGrMsJkVT+C8X3txWUGoVSj/IjHTP2YfZysmWwf60BIDzgv
 PDcWI3N/vu8A==
X-IronPort-AV: E=Sophos;i="5.75,348,1589241600"; 
   d="scan'208";a="41593020"
Subject: Re: [PATCH V2 net-next 1/7] net: ena: avoid unnecessary rearming of
 interrupt vector when busy-polling
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-2c-cc689b93.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 13 Jul 2020 19:40:04 +0000
Received: from EX13MTAUEA002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2c-cc689b93.us-west-2.amazon.com (Postfix) with ESMTPS id EE896120D98;
        Mon, 13 Jul 2020 19:40:02 +0000 (UTC)
Received: from EX13D28EUC001.ant.amazon.com (10.43.164.4) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 13 Jul 2020 19:40:02 +0000
Received: from ua97a68a4e7db56.ant.amazon.com.amazon.com (10.43.161.146) by
 EX13D28EUC001.ant.amazon.com (10.43.164.4) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 13 Jul 2020 19:39:47 +0000
References: <1594593371-14045-1-git-send-email-akiyano@amazon.com> <1594593371-14045-2-git-send-email-akiyano@amazon.com> <3f3cc8e6-a5fd-44f7-7a86-8862e296c40c@gmail.com>
User-agent: mu4e 1.4.10; emacs 26.3
From:   Shay Agroskin <shayagr@amazon.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
CC:     <akiyano@amazon.com>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, <dwmw@amazon.com>, <zorik@amazon.com>,
        <matua@amazon.com>, <saeedb@amazon.com>, <msw@amazon.com>,
        <aliguori@amazon.com>, <nafea@amazon.com>, <gtzalik@amazon.com>,
        <netanel@amazon.com>, <alisaidi@amazon.com>, <benh@amazon.com>,
        <ndagan@amazon.com>, <sameehj@amazon.com>
In-Reply-To: <3f3cc8e6-a5fd-44f7-7a86-8862e296c40c@gmail.com>
Date:   Mon, 13 Jul 2020 22:39:38 +0300
Message-ID: <pj41zlk0z7rypx.fsf@ua97a68a4e7db56.ant.amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [10.43.161.146]
X-ClientProxiedBy: EX13D19UWC001.ant.amazon.com (10.43.162.64) To
 EX13D28EUC001.ant.amazon.com (10.43.164.4)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Eric Dumazet <eric.dumazet@gmail.com> writes:

> CAUTION: This email originated from outside of the organization. Do not c=
lick links or open attachments unless you can confirm the sender and know t=
he content is safe.
>
>
>
> On 7/12/20 3:36 PM, akiyano@amazon.com wrote:
>> From: Arthur Kiyanovski <akiyano@amazon.com>
>>
>> In napi busy-poll mode, the kernel invokes the napi handler of the
>> device repeatedly to poll the NIC's receive queues. This process
>> repeats until a timeout, specific for each connection, is up.
>> By polling packets in busy-poll mode the user may gain lower latency
>> and higher throughput (since the kernel no longer waits for interrupts
>> to poll the queues) in expense of CPU usage.
>>
>> Upon completing a napi routine, the driver checks whether
>> the routine was called by an interrupt handler. If so, the driver
>> re-enables interrupts for the device. This is needed since an
>> interrupt routine invocation disables future invocations until
>> explicitly re-enabled.
>>
>> The driver avoids re-enabling the interrupts if they were not disabled
>> in the first place (e.g. if driver in busy mode).
>> Originally, the driver checked whether interrupt re-enabling is needed
>> by reading the 'ena_napi->unmask_interrupt' variable. This atomic
>> variable was set upon interrupt and cleared after re-enabling it.
>>
>> In the 4.10 Linux version, the 'napi_complete_done' call was changed
>> so that it returns 'false' when device should not re-enable
>> interrupts, and 'true' otherwise. The change includes reading the
>> "NAPIF_STATE_IN_BUSY_POLL" flag to check if the napi call is in
>> busy-poll mode, and if so, return 'false'.
>> The driver was changed to re-enable interrupts according to this
>> routine's return value.
>> The Linux community rejected the use of the
>> 'ena_napi->unmaunmask_interrupt' variable to determine whether
>> unmasking is needed, and urged to use napi_napi_complete_done()
>> return value solely.
>> See https://lore.kernel.org/patchwork/patch/741149/ for more details
>
> Yeah, and I see you did not bother to CC me on this new submission.
>

I apologize for this. We should have been more careful. We'll take
better notice next time

>>
>> As explained, a busy-poll session exists for a specified timeout
>> value, after which it exits the busy-poll mode and re-enters it later.
>> This leads to many invocations of the napi handler where
>> napi_complete_done() false indicates that interrupts should be
>> re-enabled.
>> This creates a bug in which the interrupts are re-enabled
>> unnecessarily.
>> To reproduce this bug:
>>     1) echo 50 | sudo tee /proc/sys/net/core/busy_poll
>>     2) echo 50 | sudo tee /proc/sys/net/core/busy_read
>>     3) Add counters that check whether
>>     'ena_unmask_interrupt(tx_ring, rx_ring);'
>>     is called without disabling the interrupts in the first
>>     place (i.e. with calling the interrupt routine
>>     ena_intr_msix_io())
>>
>> Steps 1+2 enable busy-poll as the default mode for new connections.
>>
>> The busy poll routine rearms the interrupts after every session by
>> design, and so we need to add an extra check that the interrupts were
>> masked in the first place.
>>
>> Signed-off-by: Shay Agroskin <shayagr@amazon.com>
>> Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
>> ---
>>  drivers/net/ethernet/amazon/ena/ena_netdev.c | 7 ++++++-
>>  drivers/net/ethernet/amazon/ena/ena_netdev.h | 1 +
>>  2 files changed, 7 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/=
ethernet/amazon/ena/ena_netdev.c
>> index 91be3ffa1c5c..90c0fe15cd23 100644
>> --- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
>> +++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
>> @@ -1913,7 +1913,9 @@ static int ena_io_poll(struct napi_struct *napi, i=
nt budget)
>>               /* Update numa and unmask the interrupt only when schedule
>>                * from the interrupt context (vs from sk_busy_loop)
>>                */
>> -             if (napi_complete_done(napi, rx_work_done)) {
>> +             if (napi_complete_done(napi, rx_work_done) &&
>> +                 READ_ONCE(ena_napi->interrupts_masked)) {
>> +                     WRITE_ONCE(ena_napi->interrupts_masked, false);
>>                       /* We apply adaptive moderation on Rx path only.
>>                        * Tx uses static interrupt moderation.
>>                        */
>> @@ -1961,6 +1963,9 @@ static irqreturn_t ena_intr_msix_io(int irq, void =
*data)
>>
>>       ena_napi->first_interrupt =3D true;
>>
>> +     WRITE_ONCE(ena_napi->interrupts_masked, true);
>> +     smp_wmb(); /* write interrupts_masked before calling napi */
>
> It is not clear where is the paired smp_wmb()
>
Can you please explain what you mean ? The idea of adding the store barrier=
 here is to ensure that the WRITE_ONCE(=E2=80=A6) invocation is executed be=
fore
invoking the napi soft irq. From what I gathered using this command would r=
esult in compiler barrier (which would prevent it from executing the bool s=
tore after napi scheduling) on x86
and a memory barrier on ARM64 machines which have a weaker consistency mode=
l.
>> +
>>       napi_schedule_irqoff(&ena_napi->napi);
>>
>>       return IRQ_HANDLED;
>> diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.h b/drivers/net/=
ethernet/amazon/ena/ena_netdev.h
>> index ba030d260940..89304b403995 100644
>> --- a/drivers/net/ethernet/amazon/ena/ena_netdev.h
>> +++ b/drivers/net/ethernet/amazon/ena/ena_netdev.h
>> @@ -167,6 +167,7 @@ struct ena_napi {
>>       struct ena_ring *rx_ring;
>>       struct ena_ring *xdp_ring;
>>       bool first_interrupt;
>> +     bool interrupts_masked;
>>       u32 qid;
>>       struct dim dim;
>>  };
>>
>
> Note that writing/reading over bool fields from hard irq context without =
proper sync is not generally allowed.
>
> Compiler could perform RMW over plain 32bit words.

Doesn't the READ/WRITE_ONCE macros prevent the compiler from reordering the=
se instructions ? Also from what I researched (please correct me if I'm wro=
ng here)
both x86 and ARM don't allow reordering LOAD and STORE when they access
the same variable (register or memory address).
>
> Sometimes we accept the races, but in this context this might be bad.

As long a the writing of the flag is atomic in the sense that the value in =
memory isn't some hybrid value of two parallel stores, the existing race ca=
nnot result in a dead lock or
leaving the interrupt vector masked. Am I missing something ?

Thank you for taking the time to look at this patch.

Shay

