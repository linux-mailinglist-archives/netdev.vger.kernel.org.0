Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8542497C62
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 10:46:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236784AbiAXJqm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 04:46:42 -0500
Received: from out30-54.freemail.mail.aliyun.com ([115.124.30.54]:40210 "EHLO
        out30-54.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236762AbiAXJqm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 04:46:42 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R531e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0V2iaJMa_1643017599;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0V2iaJMa_1643017599)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 24 Jan 2022 17:46:40 +0800
Date:   Mon, 24 Jan 2022 17:46:39 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     Karsten Graul <kgraul@linux.ibm.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [PATCH net-next] net/smc: Use kvzalloc for allocating
 smc_link_group
Message-ID: <Ye51fyoWrXTevmLa@TonyMac-Alibaba>
Reply-To: Tony Lu <tonylu@linux.alibaba.com>
References: <20220120140928.7137-1-tonylu@linux.alibaba.com>
 <4c600724-3306-0f0e-36dc-52f4f23825bc@linux.ibm.com>
 <YeoncJZoa3ELWyxM@TonyMac-Alibaba>
 <c5873d85-d791-319b-e3a1-86abda204b45@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c5873d85-d791-319b-e3a1-86abda204b45@linux.ibm.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 21, 2022 at 12:06:56PM +0100, Karsten Graul wrote:
> On 21/01/2022 04:24, Tony Lu wrote:
> > On Thu, Jan 20, 2022 at 03:50:26PM +0100, Karsten Graul wrote:
> >> On 20/01/2022 15:09, Tony Lu wrote:
> >>> When analyzed memory usage of SMC, we found that the size of struct
> >>> smc_link_group is 16048 bytes, which is too big for a busy machine to
> >>> allocate contiguous memory. Using kvzalloc instead that falls back to
> >>> vmalloc if there has not enough contiguous memory.
> >>
> >> I am wondering where the needed contiguous memory for the required RMB buffers should come from when 
> >> you don't even get enough storage for the initial link group?
> > 
> > Yes, this is what I want to talking about. The RMB buffers size inherits
> > from TCP, we cannot assume that RMB is always larger than 16k bytes, the
> > tcp_mem can be changed on the fly, and it can be tuned to very small for
> > saving memory. Also, If we freed existed link group or somewhere else,
> > we can allocate enough contiguous memory for the new link group.
> 
> The lowest size for an RMB is 16kb, smaller inherited tcp sizes do not apply here.

Yes, for my unclear description, this is the corner case for RMB is not
always larger than 16kib, equal is a possible scene.

> > 
> >> The idea is that when the system is so low on contiguous memory then a link group creation should fail 
> >> early, because most of the later buffer allocations will also fail then later.
> > 
> > IMHO, it is not a "pre-checker" for allocating buffer, it is a reminder
> > for us to save contiguous memory, this is a precious resource, and a
> > possible way to do this. This patch is not the best approach to solve
> > this problem, but the simplest one. A possible approach to allocate
> > link array in link group with a pointer to another memory. Glad to hear
> > your advice.
> 
> I am still not fully convinced of this change. It does not harm and the overhead of
> a vmalloc() is acceptable because a link group is not created so often. But since
> kvzmalloc() will first try to use normal kmalloc() and if that fails switch to the
> (more expensive) vmalloc() this will not _save_ any contiguous memory.
> And for the subsequent required allocations of at least one RMB we need another 16KB.

I agree with you. kvzmalloc doesn't save contiguous memory for the most
time, only when high order contiguous memory is used out, or malloc link
group when another link group just freed its buffer. This race window is
too small to reach it in real world.

I prepare a complete solution for this. After analyzed memory footprint
of structures in SMC, struct smc_link_group is the largest struction,
here is the detailed fields:

struct smc_link_group {
        struct list_head           list;                 /*     0    16 */
        struct rb_root             conns_all;            /*    16     8 */
        rwlock_t                   conns_lock;           /*    24     8 */
        unsigned int               conns_num;            /*    32     4 */
        short unsigned int         vlan_id;              /*    36     2 */

        /* XXX 2 bytes hole, try to pack */

        struct list_head           sndbufs[16];          /*    40   256 */
        /* --- cacheline 4 boundary (256 bytes) was 40 bytes ago --- */
        struct mutex               sndbufs_lock;         /*   296    32 */
        /* --- cacheline 5 boundary (320 bytes) was 8 bytes ago --- */
        struct list_head           rmbs[16];             /*   328   256 */
        /* --- cacheline 9 boundary (576 bytes) was 8 bytes ago --- */
        struct mutex               rmbs_lock;            /*   584    32 */
        u8                         id[4];                /*   616     4 */

        /* XXX 4 bytes hole, try to pack */

        struct delayed_work        free_work;            /*   624    88 */

        /* XXX last struct has 4 bytes of padding */

        /* --- cacheline 11 boundary (704 bytes) was 8 bytes ago --- */
        struct work_struct         terminate_work;       /*   712    32 */
        struct workqueue_struct *  tx_wq;                /*   744     8 */
        u8                         sync_err:1;           /*   752: 0  1 */
        u8                         terminating:1;        /*   752: 1  1 */
        u8                         freeing:1;            /*   752: 2  1 */

        /* XXX 5 bits hole, try to pack */

        bool                       is_smcd;              /*   753     1 */
        u8                         smc_version;          /*   754     1 */
        u8                         negotiated_eid[32];   /*   755    32 */
        /* --- cacheline 12 boundary (768 bytes) was 19 bytes ago --- */
        u8                         peer_os;              /*   787     1 */
        u8                         peer_smc_release;     /*   788     1 */
        u8                         peer_hostname[32];    /*   789    32 */

        /* XXX 3 bytes hole, try to pack */

        union {
                struct {
                        enum smc_lgr_role role;          /*   824     4 */

                        /* XXX 4 bytes hole, try to pack */

                        /* --- cacheline 13 boundary (832 bytes) --- */
                        struct smc_link lnk[3];          /*   832  2616 */
                        /* --- cacheline 53 boundary (3392 bytes) was 56 bytes ago --- */
                        struct smc_wr_v2_buf * wr_rx_buf_v2; /*  3448     8 */
                        /* --- cacheline 54 boundary (3456 bytes) --- */
                        struct smc_wr_v2_buf * wr_tx_buf_v2; /*  3456     8 */
                        char       peer_systemid[8];     /*  3464     8 */
                        struct smc_rtoken rtokens[255][3]; /*  3472 12240 */
                        /* --- cacheline 245 boundary (15680 bytes) was 32 bytes ago --- */
                        long unsigned int rtokens_used_mask[4]; /* 15712    32 */
                        /* --- cacheline 246 boundary (15744 bytes) --- */
                        u8         next_link_id;         /* 15744     1 */

                        /* XXX 3 bytes hole, try to pack */

                        enum smc_lgr_type type;          /* 15748     4 */
                        u8         pnet_id[17];          /* 15752    17 */

                        /* XXX 7 bytes hole, try to pack */

                        struct list_head llc_event_q;    /* 15776    16 */
                        spinlock_t llc_event_q_lock;     /* 15792     4 */

                        /* XXX 4 bytes hole, try to pack */

                        struct mutex llc_conf_mutex;     /* 15800    32 */
                        /* --- cacheline 247 boundary (15808 bytes) was 24 bytes ago --- */
                        struct work_struct llc_add_link_work; /* 15832    32 */
                        struct work_struct llc_del_link_work; /* 15864    32 */
                        /* --- cacheline 248 boundary (15872 bytes) was 24 bytes ago --- */
                        struct work_struct llc_event_work; /* 15896    32 */
                        wait_queue_head_t llc_flow_waiter; /* 15928    24 */
                        /* --- cacheline 249 boundary (15936 bytes) was 16 bytes ago --- */
                        wait_queue_head_t llc_msg_waiter; /* 15952    24 */
                        struct smc_llc_flow llc_flow_lcl; /* 15976    16 */
                        struct smc_llc_flow llc_flow_rmt; /* 15992    16 */
                        /* --- cacheline 250 boundary (16000 bytes) was 8 bytes ago --- */
                        struct smc_llc_qentry * delayed_event; /* 16008     8 */
                        spinlock_t llc_flow_lock;        /* 16016     4 */
                        int        llc_testlink_time;    /* 16020     4 */
                        u32        llc_termination_rsn;  /* 16024     4 */
                        u8         nexthop_mac[6];       /* 16028     6 */
                        u8         uses_gateway;         /* 16034     1 */

                        /* XXX 1 byte hole, try to pack */

                        __be32     saddr;                /* 16036     4 */
                        struct net * net;                /* 16040     8 */
                };                                       /*   824 15224 */
                struct {
                        u64        peer_gid;             /*   824     8 */
                        /* --- cacheline 13 boundary (832 bytes) --- */
                        struct smcd_dev * smcd;          /*   832     8 */
                        u8         peer_shutdown:1;      /*   840: 0  1 */
                };                                       /*   824    24 */
        };                                               /*   824 15224 */

        /* size: 16048, cachelines: 251, members: 23 */
        /* sum members: 16038, holes: 3, sum holes: 9 */
        /* sum bitfield members: 3 bits, bit holes: 1, sum bit holes: 5 bits */
        /* paddings: 1, sum paddings: 4 */
        /* last cacheline: 48 bytes */
};

These fields use most of memory in struct smc_link_group.

struct smc_link lnk[3];          /*   832  2616 */
struct smc_rtoken rtokens[255][3]; /*  3472 12240 */

There is a possible to spread this large allocation to multiple
contiguous allocations, try to keep allocating one page every time.
 
# Appendix

There are background information about this and following patches. We
are working on optimizing memory usage to expand the usage scenarios.
such as container environment. These scenarios have a common trait that
the resource is limited, especially memory (contiguous memory is the most).

So we are working on some methods to reduce memory usage, such as:
- reduce corners' memory usage, for example this patch mentions;
- flexible release reused link group buffer, manual or based on mem
  cgroup pressure;
- NIC non-contiguous DMA memory, try to reduce contiguous memory usage;
- elastic memory for allocating more memory when needed and release when
  free;
- tunable snd/rcv buffer and unbind them from TCP;

These methods trade off performance and flexibility. The detailed
designs are still working. We will send RFCs out when they are clear,
and glad to receive your advice. This patch is so trivial that I sent it
out now.

Thanks,
Tony Lu
