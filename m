Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1B996B6FAA
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 07:54:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229561AbjCMGyP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 02:54:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229552AbjCMGyO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 02:54:14 -0400
Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.126.135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D3BB212BE
        for <netdev@vger.kernel.org>; Sun, 12 Mar 2023 23:54:12 -0700 (PDT)
Received: from [192.168.0.10] ([176.126.68.120]) by mrelayeu.kundenserver.de
 (mreue010 [212.227.15.167]) with ESMTPSA (Nemesis) id
 1M9nlN-1pfCLr1okn-005oYW; Mon, 13 Mar 2023 07:48:54 +0100
Message-ID: <9f1e4087-239e-3a1a-dc35-59a4680e676b@kpanic.de>
Date:   Mon, 13 Mar 2023 07:48:52 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH net] iavf: fix hang on reboot with ice
Content-Language: de-DE
To:     Michal Kubiak <michal.kubiak@intel.com>
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, patryk.piotrowski@intel.com,
        slawomirx.laba@intel.com
References: <20230310122653.1116051-1-sassmann@kpanic.de>
 <ZAtnqlHZ02EJn5xt@localhost.localdomain>
From:   Stefan Assmann <sassmann@kpanic.de>
In-Reply-To: <ZAtnqlHZ02EJn5xt@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:xLQWdQU1moaqevqYxK5oNMZDVEeON8eq/vergiFwf/1bmXEN7YH
 MRCA/XAORag+LVcVTK0OVbfOoniA3SXDh8vaZ8lIuZRXzWUAZu/dnWm6cXgRefnetvMCd+1
 1GikJgKY58hX1KQ4Ke9mpd7YvWX9eP+X2vbADEFXxdhjj1dlxrajACsOigenNiatNahzSMr
 lja5uoM69A8H4oczVLBKA==
UI-OutboundReport: notjunk:1;M01:P0:nbXQaF1dUmo=;hTNnu42joIWflbtx5PH7ahB+Nom
 x/c7EffnsGbNc2kA/qbxc9D6C97k/BEYy/STZQRUggYyWlZoIG+OJweKBI2xKQ6HaYeisiCAT
 xfT/kItUvRzLJwynmipf7qmS0JhKK+6bEilF3/JmJLM8EEAt7OlxEZVpiZF30/sad9MB/lKYS
 JiFEKo/QpYhKEs3x65aJGYhw00do1qTeETFnuwe84xzSj0X78t9ivpe+lJbNrYLLNocEuOhFZ
 xjydu1sSpq46tNJEDH86r24cp4CLxY9NZnqdR0XrT5BxSnUKdXGHHVbvFByrVg91S2OvzTMBM
 Kj60vH2g/gC8Cs2lCL116aQcIB5qEIp34ev68GAY+LEZXdNeE4fF/DkLiF9IW4vMpLL/LahFK
 FiA/D6lu2UROzpcIuQtUcqQJlP7G1KRcfSb/jKnlfX6xrk1xKAzCMfbE11r1+7LseglcApGGz
 WYgbh/i8OidyyDyUMUZaedZGGlTNpnhuKX0PfFadvZAQb20wecGuTaazk6yBlCaoHuh2lgOfq
 XyxhzXQSRS5hNZJSs0cN639PwG8sTmtM2FwaKIIxtCKIe6givmohWG4TrcZ6+7EXiVtm8XYnt
 5aXKoXHOTIvlmg2Rgq8VrFCpRf+sDpq5yXtu+JUCkW56zzbjRM2EYvTjuaDi853yQCX5TE3s8
 RSj6ojJPF9wRPsWUj1vEt3HYockOTwI7cO+KiOTq2w==
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10.03.23 18:24, Michal Kubiak wrote:
> On Fri, Mar 10, 2023 at 01:26:53PM +0100, Stefan Assmann wrote:
>> When a system with E810 with existing VFs gets rebooted the following
>> hang may be observed.
>>
>>  Pid 1 is hung in iavf_remove(), part of a network driver:
>>  PID: 1        TASK: ffff965400e5a340  CPU: 24   COMMAND: "systemd-shutdow"
>>   #0 [ffffaad04005fa50] __schedule at ffffffff8b3239cb
>>   #1 [ffffaad04005fae8] schedule at ffffffff8b323e2d
>>   #2 [ffffaad04005fb00] schedule_hrtimeout_range_clock at ffffffff8b32cebc
>>   #3 [ffffaad04005fb80] usleep_range_state at ffffffff8b32c930
>>   #4 [ffffaad04005fbb0] iavf_remove at ffffffffc12b9b4c [iavf]
>>   #5 [ffffaad04005fbf0] pci_device_remove at ffffffff8add7513
>>   #6 [ffffaad04005fc10] device_release_driver_internal at ffffffff8af08baa
>>   #7 [ffffaad04005fc40] pci_stop_bus_device at ffffffff8adcc5fc
>>   #8 [ffffaad04005fc60] pci_stop_and_remove_bus_device at ffffffff8adcc81e
>>   #9 [ffffaad04005fc70] pci_iov_remove_virtfn at ffffffff8adf9429
>>  #10 [ffffaad04005fca8] sriov_disable at ffffffff8adf98e4
>>  #11 [ffffaad04005fcc8] ice_free_vfs at ffffffffc04bb2c8 [ice]
>>  #12 [ffffaad04005fd10] ice_remove at ffffffffc04778fe [ice]
>>  #13 [ffffaad04005fd38] ice_shutdown at ffffffffc0477946 [ice]
>>  #14 [ffffaad04005fd50] pci_device_shutdown at ffffffff8add58f1
>>  #15 [ffffaad04005fd70] device_shutdown at ffffffff8af05386
>>  #16 [ffffaad04005fd98] kernel_restart at ffffffff8a92a870
>>  #17 [ffffaad04005fda8] __do_sys_reboot at ffffffff8a92abd6
>>  #18 [ffffaad04005fee0] do_syscall_64 at ffffffff8b317159
>>  #19 [ffffaad04005ff08] __context_tracking_enter at ffffffff8b31b6fc
>>  #20 [ffffaad04005ff18] syscall_exit_to_user_mode at ffffffff8b31b50d
>>  #21 [ffffaad04005ff28] do_syscall_64 at ffffffff8b317169
>>  #22 [ffffaad04005ff50] entry_SYSCALL_64_after_hwframe at ffffffff8b40009b
>>      RIP: 00007f1baa5c13d7  RSP: 00007fffbcc55a98  RFLAGS: 00000202
>>      RAX: ffffffffffffffda  RBX: 0000000000000000  RCX: 00007f1baa5c13d7
>>      RDX: 0000000001234567  RSI: 0000000028121969  RDI: 00000000fee1dead
>>      RBP: 00007fffbcc55ca0   R8: 0000000000000000   R9: 00007fffbcc54e90
>>      R10: 00007fffbcc55050  R11: 0000000000000202  R12: 0000000000000005
>>      R13: 0000000000000000  R14: 00007fffbcc55af0  R15: 0000000000000000
>>      ORIG_RAX: 00000000000000a9  CS: 0033  SS: 002b
>>
>> During reboot all drivers PM shutdown callbacks are invoked.
>> In iavf_shutdown() the adapter state is changed to __IAVF_REMOVE.
>> In ice_shutdown() the call chain above is executed, which at some point
>> calls iavf_remove(). However iavf_remove() expects the VF to be in one
>> of the states __IAVF_RUNNING, __IAVF_DOWN or __IAVF_INIT_FAILED. If
>> that's not the case it sleeps forever.
>> So if iavf_shutdown() gets invoked before ice_shutdown() the system will
>> hang indefinitely because the adapter is already in state __IAVF_REMOVE.
>>
>> Fix this by adding __IAVF_REMOVE to the list of allowed states in
>> iavf_remove().
>>
>> Fixes: 974578017fc1 ("iavf: Add waiting so the port is initialized in remove")
>> Reported-by: Marius Cornea <mcornea@redhat.com>
>> Signed-off-by: Stefan Assmann <sassmann@kpanic.de>
>> ---
>>  drivers/net/ethernet/intel/iavf/iavf_main.c | 3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
>> index 3273aeb8fa67..83ef3a343ef0 100644
>> --- a/drivers/net/ethernet/intel/iavf/iavf_main.c
>> +++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
>> @@ -5062,7 +5062,8 @@ static void iavf_remove(struct pci_dev *pdev)
>>  		mutex_lock(&adapter->crit_lock);
>>  		if (adapter->state == __IAVF_RUNNING ||
>>  		    adapter->state == __IAVF_DOWN ||
>> -		    adapter->state == __IAVF_INIT_FAILED) {
>> +		    adapter->state == __IAVF_INIT_FAILED ||
>> +		    adapter->state == __IAVF_REMOVE) {
>>  			mutex_unlock(&adapter->crit_lock);
>>  			break;
>>  		}
> 
> Adding the __IAVF_REMOVE state to the loop break condition seems OK to
> me.
> I would only consider adding a timeout to this loop to prevent endless hangs
> for other potential corner cases.

Hi Michal,

is it okay to add this change in a follow-up patch? I'd like to get this
patch merged quickly since we have a customer being blocked by this
issue.

Thanks!

  Stefan
