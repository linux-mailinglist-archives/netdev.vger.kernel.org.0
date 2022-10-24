Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E8AA609C08
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 10:05:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230017AbiJXIFA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 04:05:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230133AbiJXIEy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 04:04:54 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1054612A85
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 01:04:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666598687;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FKBAEtYDhYxvbrfowcbQc374/J9V2taQhoJdURlAyQA=;
        b=gGo/5BMLnfrv0VRGP0/H2gkmK/Y5aP6vRh3qp/pfIunNVzmeaHtoVZcL4wCcF4Akjhcvv7
        XupmOKbB77Wbfe5ZHZz9cvV+mTYRFpi35Czir1Ng5Rckal6qtp0oy2G+kpf8UJDaBEpmad
        9NkM5BgpTolLkJkwhqOtAR8vpt4T9F4=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-669-gQ-xzGwTMKCYKKXkbfbTCw-1; Mon, 24 Oct 2022 04:04:45 -0400
X-MC-Unique: gQ-xzGwTMKCYKKXkbfbTCw-1
Received: by mail-ed1-f70.google.com with SMTP id w20-20020a05640234d400b0045d0d1afe8eso8787993edc.15
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 01:04:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FKBAEtYDhYxvbrfowcbQc374/J9V2taQhoJdURlAyQA=;
        b=gM+9GDbnkN4BQ92MQOLautgVTlM8p2rsgnX5HrQJE66bG6A7nWGVSWNRBTNZaFxbHf
         wZCJVe7K/YUz7t7QDyZNczkw4ByNzELS4FNcKeCT6BuemCjxOTVnJC17EZRU1D4kEAIT
         ZCqpRICdXLcZ5MxIhOH4fM6gJ2kDHYGh6gbq0fIubjWrBGLguNSLQKi7frrzSBs/1fF9
         DHj3AUbjr547DK97GMuxV3FcIT+YmCKjYrh1podnF1ZCpKculaoQct0C7rYlzs84e52z
         5fjpQDisc4pdHo2oVGFYlEtA51PVA1Zqrwt2vNIxt+tSBck95VUXU2UZnDQK7xFWK66G
         gmpw==
X-Gm-Message-State: ACrzQf0f9goMQNPj+pz3FOAKqOk6fmx4tb2t307WqhKElll4jBq9ucyz
        UUueMMAs4ouXR0yohvK/wSHwBAoJPBpTlQhkpzJ+fbVdPQTjamVZda30B6lLk5aVUjfDUcHpvV6
        Zz03x4ZWLzd63C61V
X-Received: by 2002:a17:907:7f8e:b0:7aa:7598:126d with SMTP id qk14-20020a1709077f8e00b007aa7598126dmr571691ejc.289.1666598684060;
        Mon, 24 Oct 2022 01:04:44 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6dGgv/1IMKLKypo8db5XzA2U3gzSInS58FkJCWJpD4caN5iApucaoF4PBHP3vRkauSpseTaA==
X-Received: by 2002:a17:907:7f8e:b0:7aa:7598:126d with SMTP id qk14-20020a1709077f8e00b007aa7598126dmr571673ejc.289.1666598683782;
        Mon, 24 Oct 2022 01:04:43 -0700 (PDT)
Received: from [10.40.98.142] ([78.108.130.194])
        by smtp.gmail.com with ESMTPSA id en9-20020a056402528900b00461bd82581asm1832118edb.84.2022.10.24.01.04.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Oct 2022 01:04:43 -0700 (PDT)
Message-ID: <ea022df4-2baf-48ae-e5ed-85a6242a5774@redhat.com>
Date:   Mon, 24 Oct 2022 10:04:42 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [PATCH] net: wwan: iosm: initialize pc_wwan->if_mutex earlier
Content-Language: en-US
To:     Sergey Ryazanov <ryazanov.s.a@gmail.com>
Cc:     M Chetan Kumar <m.chetan.kumar@intel.com>,
        Intel Corporation <linuxwwan@intel.com>,
        Loic Poulain <loic.poulain@linaro.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        netdev@vger.kernel.org
References: <20221014093632.8487-1-hdegoede@redhat.com>
 <CAHNKnsSvvM3_JEdr1znAWTup-LG-A=cuO8h-A8G6Cwf=h_rjNQ@mail.gmail.com>
From:   Hans de Goede <hdegoede@redhat.com>
In-Reply-To: <CAHNKnsSvvM3_JEdr1znAWTup-LG-A=cuO8h-A8G6Cwf=h_rjNQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 10/15/22 09:55, Sergey Ryazanov wrote:
> On Fri, Oct 14, 2022 at 1:36 PM Hans de Goede <hdegoede@redhat.com> wro=
te:
>> wwan_register_ops() ends up calls ipc_wwan_newlink() before it returns=
=2E
>>
>> ipc_wwan_newlink() uses pc_wwan->if_mutex, so we must initialize it
>> before calling wwan_register_ops(). This fixes the following WARN()
>> when lock-debugging is enabled:
>>
>> [  610.708713] ------------[ cut here ]------------
>> [  610.708721] DEBUG_LOCKS_WARN_ON(lock->magic !=3D lock)
>> [  610.708727] WARNING: CPU: 11 PID: 506 at kernel/locking/mutex.c:582=
 __mutex_lock+0x3e4/0x7e0
>> [  610.708736] Modules linked in: iosm snd_seq_dummy snd_hrtimer rfcom=
m qrtr bnep binfmt_misc snd_ctl_led snd_soc_skl_hda_dsp snd_soc_intel_hda=
_dsp_common snd_soc_hdac_hdmi snd_sof_probes snd_soc_dmic iTCO_wdt intel_=
pmc_bxt mei_hdcp mei_pxp iTCO_vendor_support pmt_telemetry intel_rapl_msr=
 pmt_class intel_tcc_cooling x86_pkg_temp_thermal intel_powerclamp corete=
mp kvm_intel kvm irqbypass rapl intel_cstate intel_uncore pcspkr think_lm=
i firmware_attributes_class wmi_bmof snd_hda_codec_hdmi snd_hda_codec_rea=
ltek snd_hda_codec_generic snd_sof_pci_intel_tgl snd_sof_intel_hda_common=
 soundwire_intel soundwire_generic_allocation soundwire_cadence snd_sof_i=
ntel_hda snd_sof_pci snd_sof_xtensa_dsp snd_sof snd_sof_utils snd_soc_hda=
c_hda snd_hda_ext_core snd_soc_acpi_intel_match snd_soc_acpi soundwire_bu=
s snd_soc_core snd_compress ac97_bus snd_pcm_dmaengine snd_hda_intel snd_=
intel_dspcfg snd_intel_sdw_acpi snd_hda_codec snd_hda_core iwlmvm snd_hwd=
ep snd_seq btusb snd_seq_device btrtl btbcm snd_pcm
>> [  610.708767]  btintel mei_me mac80211 i2c_i801 btmtk libarc4 i2c_smb=
us snd_timer mei bluetooth hid_sensor_gyro_3d iwlwifi hid_sensor_accel_3d=
 idma64 hid_sensor_trigger hid_sensor_iio_common ecdh_generic industriali=
o_triggered_buffer kfifo_buf cfg80211 joydev industrialio int3403_thermal=
 soc_button_array ov2740 v4l2_fwnode v4l2_async videodev mc intel_skl_int=
3472_tps68470 tps68470_regulator clk_tps68470 intel_skl_int3472_discrete =
intel_hid sparse_keymap int3400_thermal acpi_thermal_rel acpi_tad acpi_pa=
d vfat fat processor_thermal_device_pci processor_thermal_device processo=
r_thermal_rfim processor_thermal_mbox processor_thermal_rapl thunderbolt =
intel_rapl_common intel_vsec int340x_thermal_zone igen6_edac zram dm_cryp=
t hid_sensor_hub intel_ishtp_hid i915 thinkpad_acpi drm_buddy drm_display=
_helper snd soundcore ledtrig_audio crct10dif_pclmul wacom platform_profi=
le crc32_pclmul cec nvme intel_ish_ipc rfkill crc32c_intel ucsi_acpi hid_=
multitouch serio_raw typec_ucsi ghash_clmulni_intel
>> [  610.708798]  nvme_core video intel_ishtp ttm typec i2c_hid_acpi i2c=
_hid wmi pinctrl_tigerlake ip6_tables ip_tables i2c_dev fuse
>> [  610.708806] CPU: 11 PID: 506 Comm: kworker/11:2 Tainted: G        W=
          6.0.0+ #505
>> [  610.708809] Hardware name: LENOVO 21CEZ9Q3US/21CEZ9Q3US, BIOS N3AET=
66W (1.31 ) 09/09/2022
>> [  610.708811] Workqueue: events ipc_imem_run_state_worker [iosm]
>> [  610.708831] RIP: 0010:__mutex_lock+0x3e4/0x7e0
>> [  610.708836] Code: ff 85 c0 0f 84 9b fc ff ff 8b 15 6f 54 11 01 85 d=
2 0f 85 8d fc ff ff 48 c7 c6 f0 f0 84 94 48 c7 c7 83 07 83 94 e8 91 33 f8=
 ff <0f> 0b e9 73 fc ff ff f6 83 d1 0c 00 00 01 0f 85 4b ff ff ff 4c 89
>> [  610.708837] RSP: 0018:ffffaf0b80767a50 EFLAGS: 00010282
>> [  610.708840] RAX: 0000000000000028 RBX: 0000000000000000 RCX: 000000=
0000000000
>> [  610.708841] RDX: 0000000000000001 RSI: ffffffff948b357c RDI: 000000=
00ffffffff
>> [  610.708842] RBP: ffffaf0b80767ae0 R08: 0000000000000000 R09: ffffaf=
0b80767900
>> [  610.708843] R10: 0000000000000003 R11: ffff9c191b7fffe8 R12: 000000=
0000000002
>> [  610.708845] R13: 0000000000000000 R14: ffff9c16a3044450 R15: ffff9c=
15e342ce40
>> [  610.708846] FS:  0000000000000000(0000) GS:ffff9c18fd6c0000(0000) k=
nlGS:0000000000000000
>> [  610.708848] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> [  610.708849] CR2: 00001d40ba7bd008 CR3: 00000001d6c26002 CR4: 000000=
0000770ee0
>> [  610.708850] PKRU: 55555554
>> [  610.708851] Call Trace:
>> [  610.708852]  <TASK>
>> [  610.708856]  ? ipc_wwan_newlink+0x46/0xb0 [iosm]
>> [  610.708862]  ? wwan_port_fops_read+0x1b0/0x1b0
>> [  610.708867]  ? ipc_wwan_newlink+0x46/0xb0 [iosm]
>> [  610.708872]  ipc_wwan_newlink+0x46/0xb0 [iosm]
>> [  610.708877]  wwan_rtnl_newlink+0x7e/0xd0
>> [  610.708880]  wwan_create_default_link+0x24c/0x2e0
>> [  610.708890]  wwan_register_ops+0x71/0x90
>> [  610.708893]  ipc_wwan_init+0x48/0x90 [iosm]
>> [  610.708897]  ipc_imem_wwan_channel_init+0x81/0xa0 [iosm]
>> [  610.708902]  ipc_imem_run_state_worker+0xab/0x1b0 [iosm]
>> [  610.708907]  process_one_work+0x254/0x570
>> [  610.708914]  worker_thread+0x4f/0x3a0
>> [  610.708917]  ? process_one_work+0x570/0x570
>> [  610.708919]  kthread+0xf2/0x120
>> [  610.708922]  ? kthread_complete_and_exit+0x20/0x20
>> [  610.708924]  ret_from_fork+0x1f/0x30
>> [  610.708931]  </TASK>
>> [  610.708931] irq event stamp: 89949
>> [  610.708933] hardirqs last  enabled at (89949): [<ffffffff93ebc630>]=
 _raw_spin_unlock_irqrestore+0x30/0x60
>> [  610.708936] hardirqs last disabled at (89948): [<ffffffff93ebc3bf>]=
 _raw_spin_lock_irqsave+0x5f/0x70
>> [  610.708938] softirqs last  enabled at (89876): [<ffffffff93bc2509>]=
 __netdev_alloc_skb+0xe9/0x150
>> [  610.708942] softirqs last disabled at (89874): [<ffffffff93bc2509>]=
 __netdev_alloc_skb+0xe9/0x150
>> [  610.708944] ---[ end trace 0000000000000000 ]---
>>
>> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
>=20
> Should we add a Fixes: tag for this change? Besides this:

This issue was present already in the driver as originally introduced, so=
:

Fixes: 2a54f2c77934 ("net: iosm: net driver")

I guess?
=20
> Reviewed-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>

Thank you.

Regards,

Hans


