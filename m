Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 522461D4344
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 03:58:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727845AbgEOB6D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 21:58:03 -0400
Received: from mo-csw1514.securemx.jp ([210.130.202.153]:60968 "EHLO
        mo-csw.securemx.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727029AbgEOB6D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 21:58:03 -0400
Received: by mo-csw.securemx.jp (mx-mo-csw1514) id 04F1vpEE019955; Fri, 15 May 2020 10:57:51 +0900
X-Iguazu-Qid: 34trWq5axJpfcHTLpk
X-Iguazu-QSIG: v=2; s=0; t=1589507870; q=34trWq5axJpfcHTLpk; m=w5eBYxUhChjcH2wqSnG8reWK/fF+ZPfw05MuqPGwb3Q=
Received: from imx12.toshiba.co.jp (imx12.toshiba.co.jp [61.202.160.132])
        by relay.securemx.jp (mx-mr1513) id 04F1vmF5022340;
        Fri, 15 May 2020 10:57:49 +0900
Received: from enc02.toshiba.co.jp ([61.202.160.51])
        by imx12.toshiba.co.jp  with ESMTP id 04F1vm6H012841;
        Fri, 15 May 2020 10:57:48 +0900 (JST)
Received: from hop101.toshiba.co.jp ([133.199.85.107])
        by enc02.toshiba.co.jp  with ESMTP id 04F1vmkV011077;
        Fri, 15 May 2020 10:57:48 +0900
From:   Punit Agrawal <punit1.agrawal@toshiba.co.jp>
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        daniel.sangorrin@toshiba.co.jp,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] e1000e: Relax condition to trigger reset for ME workaround
References: <20200512044347.3810257-1-punit1.agrawal@toshiba.co.jp>
        <CAKgT0Uf86d8wnAMSLO4hn4+mfCH5fP4e8OsAYknE0m3Y7in9gw@mail.gmail.com>
Date:   Fri, 15 May 2020 10:57:47 +0900
In-Reply-To: <CAKgT0Uf86d8wnAMSLO4hn4+mfCH5fP4e8OsAYknE0m3Y7in9gw@mail.gmail.com>
        (Alexander Duyck's message of "Thu, 14 May 2020 07:57:31 -0700")
X-TSB-HOP: ON
Message-ID: <87v9kym02s.fsf@kokedama.swc.toshiba.co.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexander Duyck <alexander.duyck@gmail.com> writes:

> On Mon, May 11, 2020 at 9:45 PM Punit Agrawal
> <punit1.agrawal@toshiba.co.jp> wrote:
>>
>> It's an error if the value of the RX/TX tail descriptor does not match
>> what was written. The error condition is true regardless the duration
>> of the interference from ME. But the code only performs the reset if
>> E1000_ICH_FWSM_PCIM2PCI_COUNT (2000) iterations of 50us delay have
>> transpired. The extra condition can lead to inconsistency between the
>> state of hardware as expected by the driver.
>>
>> Fix this by dropping the check for number of delay iterations.
>>
>> Signed-off-by: Punit Agrawal <punit1.agrawal@toshiba.co.jp>
>> Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
>> Cc: "David S. Miller" <davem@davemloft.net>
>> Cc: intel-wired-lan@lists.osuosl.org
>> Cc: netdev@vger.kernel.org
>> Cc: linux-kernel@vger.kernel.org
>> ---
>> Hi,
>>
>> The issue was noticed through code inspection while backporting the
>> workaround for TDT corruption. Sending it out as an RFC as I am not
>> familiar with the hardware internals of the e1000e.
>>
>> Another unresolved question is the inherent racy nature of the
>> workaround - the ME could block access again after releasing the
>> device (i.e., BIT(E1000_ICH_FWSM_PCIM2PCI) clear) but before the
>> driver performs the write. Has this not been a problem?
>>
>> Any feedback on the patch or the more information on the issues
>> appreciated.
>>
>> Thanks,
>> Punit
>>
>>  drivers/net/ethernet/intel/e1000e/netdev.c | 8 ++++----
>>  1 file changed, 4 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
>> index 177c6da80c57..5ed4d7ed35b3 100644
>> --- a/drivers/net/ethernet/intel/e1000e/netdev.c
>> +++ b/drivers/net/ethernet/intel/e1000e/netdev.c
>> @@ -607,11 +607,11 @@ static void e1000e_update_rdt_wa(struct e1000_ring *rx_ring, unsigned int i)
>>  {
>>         struct e1000_adapter *adapter = rx_ring->adapter;
>>         struct e1000_hw *hw = &adapter->hw;
>> -       s32 ret_val = __ew32_prepare(hw);
>>
>> +       __ew32_prepare(hw);
>>         writel(i, rx_ring->tail);
>>
>> -       if (unlikely(!ret_val && (i != readl(rx_ring->tail)))) {
>> +       if (unlikely(i != readl(rx_ring->tail))) {
>>                 u32 rctl = er32(RCTL);
>>
>>                 ew32(RCTL, rctl & ~E1000_RCTL_EN);
>> @@ -624,11 +624,11 @@ static void e1000e_update_tdt_wa(struct e1000_ring *tx_ring, unsigned int i)
>>  {
>>         struct e1000_adapter *adapter = tx_ring->adapter;
>>         struct e1000_hw *hw = &adapter->hw;
>> -       s32 ret_val = __ew32_prepare(hw);
>>
>> +       __ew32_prepare(hw);
>>         writel(i, tx_ring->tail);
>>
>> -       if (unlikely(!ret_val && (i != readl(tx_ring->tail)))) {
>> +       if (unlikely(i != readl(tx_ring->tail))) {
>>                 u32 tctl = er32(TCTL);
>>
>>                 ew32(TCTL, tctl & ~E1000_TCTL_EN);
>
> You are eliminating the timeout check in favor of just verifying if
> the write succeeded or not. Seems pretty straight forward to me.
>
> One other change you may consider making would be to drop the return
> value from __ew32_prepare since it doesn't appear to be used anywhere,
> make the function static, and maybe get rid of the prototype in
> e1000.h.
>
> Reviewed-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>

Thanks! I will send out an update dropping the return and the prototype.
